import { toSafeNavigationUrl } from "./navigateToUrl";

describe("Visualizations -> Chart -> Renderer -> toSafeNavigationUrl", () => {
  test.each([
    "https://example.com/dashboards/1?x=2",
    "http://example.com/",
    "/queries/5",
    "queries/5?p_x=1",
  ])("allows %s", url => {
    expect(toSafeNavigationUrl(url)).not.toBeNull();
  });

  test.each([
    "javascript:alert(document.cookie)",
    " JavaScript:alert(1)",
    "java\tscript:alert(1)",
    "data:text/html,<script>alert(1)</script>",
    "vbscript:msgbox(1)",
    "file:///etc/passwd",
  ])("rejects %s", url => {
    expect(toSafeNavigationUrl(url)).toBeNull();
  });

  test("rejects empty", () => {
    expect(toSafeNavigationUrl("")).toBeNull();
  });
});
