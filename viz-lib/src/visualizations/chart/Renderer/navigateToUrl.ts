// Chart click-links are built from an editor-supplied template expanded with
// query data, so only http(s) and relative URLs may be followed. Anything else
// (javascript:, data:, vbscript:, file:, ...) would run in or leave the viewer's session.
export function toSafeNavigationUrl(url: string): string | null {
  const trimmed = (url || "").trim();
  if (!trimmed) {
    return null;
  }
  let parsed: URL;
  try {
    // Parse like the browser will (strips tabs/newlines, resolves relative URLs),
    // and navigate to the parsed result so the check and the navigation agree.
    parsed = new URL(trimmed, window.location.href);
  } catch (e) {
    return null;
  }
  if (parsed.protocol !== "http:" && parsed.protocol !== "https:") {
    return null;
  }
  return parsed.href;
}

export default function navigateToUrl(url: string, shouldOpenNewTab: boolean = true) {
  const safeUrl = toSafeNavigationUrl(url);
  if (safeUrl === null) {
    console.warn("Chart link ignored: only http(s) and relative URLs are allowed.");
    return;
  }
  if (shouldOpenNewTab) {
    window.open(safeUrl, "_blank", "noopener,noreferrer");
  } else {
    window.location.href = safeUrl;
  }
}
