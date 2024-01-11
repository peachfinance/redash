import json
from unittest import mock

from redash.destinations.datadog import Datadog
from redash.models import Alert, NotificationDestination
from tests import BaseTestCase


class TestDestinationListResource(BaseTestCase):
    def test_get_returns_all_destinations(self):
        d1 = self.factory.create_destination()
        d2 = self.factory.create_destination()

        rv = self.make_request("get", "/api/destinations", user=self.factory.user)
        self.assertEqual(len(rv.json), 2)

    def test_get_returns_only_destinations_of_current_org(self):
        d1 = self.factory.create_destination()
        d2 = self.factory.create_destination()
        d3 = self.factory.create_destination(org=self.factory.create_org())

        rv = self.make_request("get", "/api/destinations", user=self.factory.user)
        self.assertEqual(len(rv.json), 2)

    def test_post_creates_new_destination(self):
        data = {
            "options": {"addresses": "test@example.com"},
            "name": "Test",
            "type": "email",
        }
        rv = self.make_request(
            "post", "/api/destinations", user=self.factory.create_admin(), data=data
        )
        self.assertEqual(rv.status_code, 200)
        pass

    def test_post_requires_admin(self):
        data = {
            "options": {"addresses": "test@example.com"},
            "name": "Test",
            "type": "email",
        }
        rv = self.make_request(
            "post", "/api/destinations", user=self.factory.user, data=data
        )
        self.assertEqual(rv.status_code, 403)

    def test_returns_400_when_name_already_exists(self):
        d1 = self.factory.create_destination()
        data = {
            "options": {"addresses": "test@example.com"},
            "name": d1.name,
            "type": "email",
        }

        rv = self.make_request(
            "post", "/api/destinations", user=self.factory.create_admin(), data=data
        )
        self.assertEqual(rv.status_code, 400)


class TestDestinationResource(BaseTestCase):
    def test_get(self):
        d = self.factory.create_destination()
        rv = self.make_request(
            "get", "/api/destinations/{}".format(d.id), user=self.factory.create_admin()
        )
        self.assertEqual(rv.status_code, 200)

    def test_delete(self):
        d = self.factory.create_destination()
        rv = self.make_request(
            "delete",
            "/api/destinations/{}".format(d.id),
            user=self.factory.create_admin(),
        )
        self.assertEqual(rv.status_code, 204)
        self.assertIsNone(NotificationDestination.query.get(d.id))

    def test_post(self):
        d = self.factory.create_destination()
        data = {
            "name": "updated",
            "type": d.type,
            "options": {"url": "https://www.slack.com/updated"},
        }

        with self.app.app_context():
            rv = self.make_request(
                "post",
                "/api/destinations/{}".format(d.id),
                user=self.factory.create_admin(),
                data=data,
            )

        self.assertEqual(rv.status_code, 200)

        d = NotificationDestination.query.get(d.id)
        self.assertEqual(d.name, data["name"])
        self.assertEqual(d.options["url"], data["options"]["url"])


def test_datadog_notify_calls_requests_post():
    alert = mock.Mock(spec_set=["id", "name", "custom_subject", "custom_body", "render_template"])
    alert.id = 1
    alert.name = "Test Alert"
    alert.custom_subject = "Test custom subject"
    alert.custom_body = "Test custom body"
    alert.render_template = mock.Mock(return_value={"Rendered": "template"})
    query = mock.Mock()
    query.id = 1

    user = mock.Mock()
    app = mock.Mock()
    host = "https://localhost:5000"
    options = {
        "api_key": "my-api-key",
        "tags": "foo:bar,zoo:baz",
        "priority": "normal",
        "source_type_name": "postgres",
    }
    metadata = {"Scheduled": False}
    new_state = Alert.TRIGGERED_STATE
    destination = Datadog(options)

    with mock.patch("redash.destinations.datadog.requests.post") as mock_post:
        mock_response = mock.Mock()
        mock_response.status_code = 202
        mock_post.return_value = mock_response

        destination.notify(alert, query, user, new_state, app, host, metadata, options)

        expected_payload = {
            "title": "Test custom subject",
            "text": "Test custom body\nQuery: https://localhost:5000/queries/1\nAlert: https://localhost:5000/alerts/1",
            "alert_type": "error",
            "priority": "normal",
            "source_type_name": "postgres",
            "aggregation_key": "redash:https://localhost:5000/alerts/1",
            "tags": [
                "foo:bar",
                "zoo:baz",
                "redash",
                "query_id:1",
                "alert_id:1",
            ],
        }

        mock_post.assert_called_once_with(
            "https://api.datadoghq.com/api/v1/events",
            data=json.dumps(expected_payload),
            headers={
                "Accept": "application/json",
                "Content-Type": "application/json",
                "DD-API-KEY": "my-api-key",
            },
            timeout=5.0,
        )

        assert mock_response.status_code == 202
