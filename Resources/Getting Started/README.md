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
  - ⚠️ Rule 4 may break functionality but is useful for uncovering hidden HTML5 elements.


  ![match-and_replace.png](https://github.com/user-attachments/assets/4385df10-c0b3-4887-b2fb-efbdb5dee574)


---

## Bug Bounty and AppSec Notes

- Look for **S3 bucket names** that 404 on page load — this can indicate a deleted bucket.
  - S3 names are globally unique. If deleted, attackers may re-register the bucket and serve malicious content.
- **Subdomain takeovers** are common with S3, especially for orphaned static sites.
- Use harmless HTML like `<b>test</b>` to detect **XSS injection** while bypassing WAFs.
- **JSON APIs** may still be vulnerable to CSRF if they fail to enforce `Content-Type`.
- Try alternate **HTTP verbs** like `GET`, `POST`, `HEAD` when testing access control. Misconfigurations often respond differently.
- Be aware of **mutative GETs** — endpoints that change state using `GET` should be considered dangerous.
- Some systems use **early-exit string comparison** for secret validation (e.g. passwords, HMACs). Timing analysis can expose these flaws.

---

## Observations and Research Ideas

- Some online compilers and code playgrounds provide outbound network access with weak sandboxing — potential abuse vector.
- [PortSwigger Web Security Academy](https://portswigger.net/web-security) remains the gold standard for free web security labs.
  - Suggestion: Add source-level examples to enhance learning.
- Trend: Moving from **cookie-based auth** to **header-based token auth** (e.g., via API proxies).
  - Reduces CSRF, introduces new risks (e.g., token leakage).
- Consider testing vulnerable apps behind enterprise WAFs to analyze evasion patterns.

---

## Tooling Notes

- Use [`semgrep`](https://semgrep.dev/) for static analysis with dynamic pattern matching.
- The **"Collaborator Everywhere"** Burp plugin helps test header injection (SSRF, Host-based behavior), but lacks full customization.
- Some **Duo integrations** with username normalization disabled may skip 2FA when arbitrary domain suffixes are supplied.

---

## Real-World Security Oddities

- Pharmacy IVR systems (e.g., Walgreens, CVS) often leak sensitive data when callers enter just a phone number and DOB.
  - ⚠️ May raise HIPAA compliance concerns due to the nature of disclosed medical information.

---

## Reading and References

- [Kubernetes Cluster Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/)
- [ExifTool RCE - CVE-2021-22204](https://devcraft.io/2021/05/04/exiftool-arbitrary-code-execution-cve-2021-22204.html)
- [IETF - The HTTP Query Method](https://www.ietf.org/archive/id/draft-ietf-httpbis-safe-method-w-body-02.html#section-4.2-2)

---

## 2025 Goals

- Become proficient in Go
- Write a useful Electron application
- Continue learning about business and investing

---
