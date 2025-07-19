# Getting Started in Cybersecurity

A collection of notes, observations, and practical advice from hands-on experience in offensive security, bug bounty hunting, and application security.

---

## General Development and Testing Tips

- **Guard Clausing**
  - Use early returns instead of nesting logic under `else`.
  - Improves readability and reduces cognitive load.

---

## Burp Suite Tips

- **Backup Your Config**
  - Path: `~/.BurpSuite/UserConfigPro.json`
  - Occasionally, Burp may fail to load extensions and overwrite this file on restart.
  - Keep a versioned backup to avoid configuration loss.

- **Search and Replace Rules**
  - Add these rules in **Proxy → Options → Match and Replace**.
  - Refresh the target app to reveal hidden functionality.
  - Note: Rule 4 may break functionality but is useful for uncovering hidden HTML5 elements.

  ![match-and_replace.png](https://github.com/user-attachments/assets/4385df10-c0b3-4887-b2fb-efbdb5dee574)

---

## Bug Bounty and AppSec Notes

- Look for **S3 bucket names** that 404 on page load — this can indicate a deleted bucket. S3 names are globally unique, and attackers can register deleted names to inject hosted content.
- **Subdomain takeovers** are common with S3, especially when static sites are hosted on a now-orphaned bucket.
- Against WAF-heavy targets, try **harmless HTML payloads** like `<b>test</b>` to identify XSS injection points without triggering filtering.
- **JSON APIs** are not always protected from CSRF. If `Content-Type` isn’t validated, CSRF may still be possible using alternate types like `application/x-www-form-urlencoded`.
- Try alternate **HTTP verbs** (GET, POST, HEAD, etc.) when encountering access control logic. Misconfigured endpoints may behave differently based on method.
- **Mutative GETs** are a real risk — GET endpoints that change state should be avoided but sometimes exist.
- Many services still use **early-exit string comparison**. Measuring timing differences in responses can reveal information about secrets like passwords or HMACs.

---

## Observations and Research Ideas

- Platforms like online compilers and interactive coding tutorials often provide network access with no outbound restrictions. Could potentially be abused if not sandboxed properly.
- PortSwigger’s Web Security Academy remains one of the best free resources for web app testing. Adding source-level code examples would make it even better.
- Many modern apps are moving away from cookie-based auth in favor of **header-based token auth** via API proxies. This changes the threat landscape, often reducing CSRF vectors.
- Consider testing **vulnerable apps behind commercial WAFs** to analyze their effectiveness using tools like Burp Pro or Nessus.

---

## Tooling Notes

- Use `semgrep` for quick static analysis with dynamic patterns.
- "Collaborator Everywhere" Burp plugin is useful for header injection testing (SSRF, header-based behavior), but limited in customization.
- Duo applications with **username normalization disabled** may fail open when arbitrary domains are supplied, skipping the 2FA prompt.

---

## Real-World Security Oddities

- Pharmacy phone systems (e.g., Walgreens, CVS) often disclose medication data with just a phone number and DOB. Raises potential HIPAA concerns due to the sensitivity of disclosed information.

---

## Reading and References

- [Kubernetes Cluster Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/)
- [ExifTool RCE - CVE-2021-22204](https://devcraft.io/2021/05/04/exiftool-arbitrary-code-execution-cve-2021-22204.html)
- [IETF Safe Method with Body Draft](https://www.ietf.org/archive/id/draft-ietf-httpbis-safe-method-w-body-02.html#section-4.2-2)

---

## 2025 Goals

- Become proficient in Go
- Write a useful Electron application
- Continue learning about business and investing

---
