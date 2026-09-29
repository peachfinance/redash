from unittest import mock

from rq import Queue

from redash.tasks import general
from tests import BaseTestCase


class TestSetupDoesNotPhoneHome(BaseTestCase):
    def test_setup_does_not_send_admin_details_upstream(self):
        form = {
            "name": "Admin",
            "email": "admin@example.com",
            "password": "correct-horse",
            "org_name": "Example",
            "security_notifications": "y",
            "newsletter": "y",
        }
        # /setup only runs in single-org mode with no org yet; the test env is multi-org
        # (org-prefixed URL map, existing "default" org), so stub those edges.
        with mock.patch("redash.handlers.setup.current_org", None), mock.patch(
            "redash.handlers.setup.settings.MULTI_ORG", False
        ), mock.patch("redash.handlers.setup.url_for", return_value="/"), mock.patch(
            "redash.handlers.setup.create_org", return_value=(self.factory.org, self.factory.user)
        ) as create_org, mock.patch.object(
            Queue, "enqueue_call", autospec=True
        ) as enqueue, mock.patch(
            "redash.tasks.general.requests.post"
        ) as post:
            rv = self.client.post("/setup", data=form)

        self.assertEqual(302, rv.status_code)
        create_org.assert_called_once_with("Example", "Admin", "admin@example.com", "correct-horse")
        # autospec records (queue, func, ...); rq may also pass func as a keyword.
        funcs = [c.kwargs.get("func", c.args[1] if len(c.args) > 1 else None) for c in enqueue.call_args_list]
        enqueued = [getattr(f, "__name__", f) for f in funcs]
        self.assertNotIn("subscribe", enqueued)
        post.assert_not_called()

    def test_subscribe_task_is_removed(self):
        self.assertFalse(hasattr(general, "subscribe"))
