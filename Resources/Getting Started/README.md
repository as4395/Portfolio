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
- Some systems use **early-exit string comparison** for secret validation (e.g., passwords, HMACs). Timing analysis can expose these flaws.

---

## Observations and Research Ideas

- Some online compilers and code playgrounds provide outbound network access with weak sandboxing — a potential abuse vector.
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

## Modern Threat Observations

It seems that the more changes are introduced, the further people are from uniformly implementing services that comply with the new standards. 
**Request smuggling-esque bugs** will only become more prevalent.

- SQLi bypass via MySQLJS escaping: 
[https://flattsecurity.medium.com/finding-an-unseen-sql-injection-by-bypassing-escape-functions-in-mysqljs-mysql-90b27f6542b4](https://flattsecurity.medium.com/finding-an-unseen-sql-injection-by-bypassing-escape-functions-in-mysqljs-mysql-90b27f6542b4)

- Anti-bot techniques for web automation: 
[https://www.zenrows.com/blog](https://www.zenrows.com/blog)

- IX-Ray toolkit: 
[https://tinyurl.com/meet-ixray](https://tinyurl.com/meet-ixray)

---

## Language-Specific Notes

### Python Tips

- It is possible to multiply two different data types. 
```python
blah = str("test123")
print(blah)
print(blah * 2)
```

Use `get` method for accessing dictionary items instead of using square brackets.

### **Right Way**

```python
alex = {
    'age': 20,
    'gender': 'M',
    'Marks': 45,
}
# using get method
print(alex.get('age'))
```

### **Wrong Way**

```python
alex = {
    'age': 20,
    'gender': 'M',
    'Marks': 45,
}
# using Square brackets
print(alex['age'])
```

### My thoughts:

In my opinion, using `get()` is often ugly and not great for readability. The baked-in exception handling will return `None` during `KeyNotFoundExceptions`. I’ve been bitten by this because `None` wasn’t handled properly. Rather, it's often better to implement context-specific exceptions for clearer error handling.


- PHP security example – execution flow and token generation: 
```php
<?php

require 'flag.php';

$input = $_GET['token'];
$input = str_replace(array("\n", "\0"), '', $input);

function generate_token(){
    $recoveryId = strtoupper(md5(uniqid('', true)));
    $recoveryId = substr(chunk_split($recoveryId, 8, '-'), -7, 18);

    if (isset($input) && $input === $recoveryId){
        load_admin_interface();
    } else {
        header("location: login.php");
    }
}

generate_token();
```
**Not sure what `generate_token()` does, but `header()` will not kill script execution — the function will still be called. The vulnerabilities are from using `md5`, a lack of uniqueness, and potential truncation.**

---

## On Phishing Tests and Human-Centric Security

- Phishing simulations should test human response, not just spam filters.
- Allow the phishing emails to reach users where possible.
- Otherwise, you're testing the filtering software, not the organization.

---

## Snippet: Automated LFI Detection

```bash
gau HOST | gf lfi | qsreplace "/etc/passwd" | xargs -I% -P 25 sh -c 'curl -s "%" 2>&1 | grep -q "root:x" && echo "VULN! %"'
```

Explanation:

`gau` – fetches archived URLs

`gf` – filters for LFI candidates (uses patterns from `gf` tool)

`qsreplace` – replaces query param values with LFI payload

`xargs/curl` – makes requests in parallel

`grep` – checks response for success signature (`root:x`)

---

## Important considerations for both blue teamers and for appsec testers:

**1.**  Do the logs contain sensitive information?
**2.**  Are the logs stored in a dedicated server?
**3.**  Can log usage generate a Denial of Service condition?
**4.**  How are they rotated? Are logs kept for the sufficient time?
**5.**  How are logs reviewed? Can administrators use these reviews to detect targeted attacks?
**6.**  How are log backups preserved?
**7.**  Is the data being logged data validated (min/max length, chars etc) prior to being logged?

---

## Security Career Advice

- Identify the most talented people in each aspect of your role: tech, reporting, work ethic.
- Learn directly from them; study their patterns.
- Don't try to learn everything — build a strong base that accelerates further learning.
- SSNs are not a safe authentication method:
- 9-digit number
- First 5 digits often derived from birth date or location
- The final 4 are brute-forceable
- Compare this to modern password policy requirements.
- Pentesters must know how to code.

--- 

## Vulnerability Case Studies

### S-52: Code-39 Vulnerable App

<img width="500" height="500" alt="Python Tip" src="https://github.com/user-attachments/assets/bd29254b-f656-4be2-8573-7f2a4632e321" />


**1.** Passwords transmitted in query string

**2.** XPATH injection present

--- 

**_“PHP is always an interesting pool for bugs. Can you spot the bug?”_**
```php
<?php
session_start();

include "connecton.php";
include "utils.php";
include "constants.php";

if(isset($_POST['email']) && isset($_POST['password'])){
    $email = $_POST['email'];
    $password = process_password($_POST["password"]);

    if($conn -> err){
        header('Location: '.$ERROR_URL."?err_code=5002");
        die('Could not connect: ' . mysqli_error($conn));
    } else {
        $result = mysqli_query($conn,"SELECT uid, role from users WHERE email=$email AND passkey=$password AND is_active=True;") or die("Query Unsuccessfull:".mysqli_error($conn));
        if($result){
            if($result -> num_rows==1){
                while($row = mysqli_fetch_array($result)) {
                    $_SESSION["session_status"] = "Start";
                    $_SESSION["session_id"] = $row["uid"];
                    $_SESSION["role"] = $row["role"];
                    header('Location: '.$DASHBOARD_URL);
                    die();
                    break;
                }
            } else {
                header('Location: '.$ERROR_URL."?err_code=6502");
                die();
            }
        }
    }
} else {
    header('Location: '.$INDEX);
    die();
}
$conn -> close();
} else {
    header('Location: '.$INDEX);
    die();
}
```

- Even if HTTPS is assumed, the password input isn’t validated.
- `process_password()` visibility is missing. It could be storing passwords in plaintext.
- `email` field is unsanitized — potential for SQL injection.
- No `die()` or `exit` used with `header()` on failed query — execution continues.

---

## Escaping Pitfalls and Payloads

```php
<?php

$input = readline('Change username: ');

//Filter HTML
function filterHTML($input) {
    $input = strip_tags($input);
    $input = str_replace('"', '\"', $input);
    $input = str_replace('\\', '\\\\', $input);
    return $input;
}

?>
<html>
<head>
    <meta src="/asset/js/main.js">
    <link rel="stylesheet" type="text/javascript" href="//asset/js/request.js">
</head>
<body>
    <form>
        <div>
            <label for="changeUsername">Change username:</label>
            <input id="changeUsername" type="text" name="text" value="<?php echo filterHTML($input); ?>">
        </div>
        <div>
            <input type="submit" value="Change" onclick="request.js">
        </div>
    </form>
</body>
</html>
```

- Escaping `"` → `\"`, `\\\"`, `\\\\\"` etc. can lead to escape of the escape.
- Escaping backslashes doesn’t guarantee safety in all contexts.
  
---

## 2FA and Usability

- Many 2FA codes are very short for usability.
- Their safety depends on fast expiration.
- If delays occur, brute-force viability increases sharply.

---

## HTML XSS Payloads and Polyglots

Example payload:
```hmtl
<h1/**/on/**/onclick=top[8680439..toString(30)]``>
```

- These use comments (/**/) to break out of filters.
- Valid but obfuscated syntax still executes.
- Great example of a polyglot-style payload.

Learn more:
[https://x55.is/brutelogic/](https://x55.is/brutelogic/)

---

## Tooling Notes

- **Burp Plugin: "Collaborator Everywhere"**
- Useful for uncovering SSRF, header injection, and header-based responses.
- Downside: limited customizability.
- Apps with referrer validation might reject probes.

<img width="402" height="209" alt="E9VW2QoXIAcpInK" src="https://github.com/user-attachments/assets/6b993f1d-1d8c-40d0-b194-9141b6ae146f" />

**Answer:**
Mixed content (http). Possible XSS, assuming that the domain is fictitious.

---

## Cloud & Infra Security

- **Scout / ScoutSuite** – used internally by AWS.
- Excellent for reviewing cloud configuration.
- Cloud pentesting is rising quickly — fun and evolving.

---

## WAFs & the Real-World Testing Debate

> “Test with the WAF on. Turning it off is cheating.”

- Real-world attackers aren't bound by the same rules.
- Being able to deploy infinite onshore boxes without fear of legal consequence is a privilege.
- It's obvious when companies rely on WAFs (like Cloudflare) as a crutch instead of addressing core app issues.

**Idea for research:**
- Put a vulnerable app behind several WAFs.
- Scan it with Burp Pro, Nessus, etc.
- Measure which WAF blocks what.

**Lawrence Berkeley National Laboratory (Berkeley Lab) chooses Cloudflare as its Zero Trust security partner**
[https://www.cloudflare.com/case-studies/lawrence-berkeley-national-laboratory](https://www.cloudflare.com/case-studies/lawrence-berkeley-national-laboratory) 
_I feel CloudFlare is pushing a bit aggressively to be the "all in one" security solution. The part about pentesting  sat uneasy with me. A WAF shouldn't be considered an alternative to pentesting or vulneranbility scanning._

---

## Emerging Threats & Questions

- Could 3D printing defeat facial recognition? High-resolution selfies → 3D modeling → bypass depth-checking authentication?

- API access control is often alarmingly bad in average web apps. Developers treat APIs like they’re not exposed.

- **SPA trend**: Cookie-based auth is dying off.
- SPAs increasingly use header-based API auth.
- Reduces risks like CSRF, but introduces new threat models.

---

## Side Observations & Thoughts

- **CDN stats** could be used to infer outages or disasters (fewer requests == power down in region?)

- **Debug mode risks**:
- [https://medium.com/@Tib3rius/the-importance-of-disabling-debug-mode-or-how-i-accidentally-hacked-a-ctf-2615cdd2feb0](https://medium.com/@Tib3rius/the-importance-of-disabling-debug-mode-or-how-i-accidentally-hacked-a-ctf-2615cdd2feb0)

---

## LFI vs LFD — Semantics Matter

- In **PHP**, `include()` executes, but `file_get_contents()` just reads.
- In that context, "LFD" is more accurate than "LFI".
- Outside PHP, “LFI” is more universally applied to both cases.

- Injections mean the **app mistakes input for code**.
- SQLi is an injection.
- LFI isn’t an injection in that sense — it's about misusing existing logic without altering it.

- **Example**: SSRF leads to LFD? Then SSRF is the root vuln, LFD is a result. Always better to name root causes.

---

## IP Grabbers & Privacy

- All IP grabbers do is log your source IP.
- You can't stop this unless you're using a proxy/VPN.

---

## Vulnerability Breakdown

**Question: What’s the deadly bug here?** 

```php
<?php

if (empty($_POST['hmac']) || empty($_POST['host'])) {
    header('HTTP/1.0 400 Bad Request');
    exit;
}

$secret = getenv("SECRET");

if (isset($_POST['nonce'])) {
    $secret = hash_hmac('sha256', $_POST['nonce'], $secret);
}

$hmac = hash_hmac('sha256', $_POST['host'], $secret);

if ($hmac !== $_POST['hmac']) {
    header('HTTP/1.0 403 Forbidden');
    exit;
}

echo exec("host " . $_POST['host']);

?>
```

**Answer:**

**1.** `hash_hmac()` errors when passed an array instead of a string.

**2.** PHP dynamically type-juggles — loose comparisons cause unexpected logic.

```php
user@hostname:~$ php -a
Interactive mode enabled
php > var_dump(hash_hmac('sha256', array(), "secret"));
PHP Warning:  hash_hmac() expects parameter 2 to be string, array given in php shell code on line 1
NULL
php > 
```

---

## Miscellaneous Security Notes

- `HTTPOnly` doesn’t fully prevent XSS-based session hijacking.
- You can’t read cookies, but can still ride a session via automation.

- **XSS Impact**:
- Often low-severity.
- But even if limited to open redirect, it is still useful for phishing.

---

## Programming Path for Hackers

**Easy route:** Python 
**Better ROI long-term:** JavaScript

- JS dominates client-side execution.
- Full-stack JS (SPAs + APIs) is now the standard. 
[https://w3techs.com/technologies/overview/client_side_language](https://w3techs.com/technologies/overview/client_side_language)

---

## Need to Deprecate SSNs 

- SSNs are widely leaked, even on clearnet:
- [http://ssndob.cc](http://ssndob.cc) (Search-only interface; do **not** buy data.)

- SSNs should be **deprecated**.
- Predictable structure.
- Brute-forceable final digits.
- Weak as an identity/auth mechanism.

---

## CSRF Vulnerabilities

> “No CSRF token on password reset/change/login/logout.”

- Don’t waste time looking for CSRF on flows that require:
- Current password (change)
- Reset token (reset)
- Login/logout — no reason to CSRF those directly

**BUT…**

- **Reset flows are often low-hanging fruit:**
- If no current password is required, CSRF becomes possible.
- Easy win.

**Edge Case: Forced Workspace Login via CSRF**
- Attack: Log out the victim, log in to the attacker’s account via CSRF.
- Trick the victim into interacting with the shared workspace they now appear to be in.
- Essentially phishing without a fake page.

## Additional Security Insights and Observations

---

### Bruteforce Reduction via CSRF

Some password reset tokens are computed using a formula such as:
```
username + time + pwhash[5:24]
```

When the epoch time of a reset request is predictable, **CSRF** can reduce the brute-force complexity by triggering token creation at known times.

---

### PHP Criticisms & Realities

- **Poor tutorial ecosystem:** Example - https://w3schools.com/php/php_superglobals_get.asp
- **Inherent design pitfalls:**
- Loose comparisons (e.g. `==`)
- Confusing operators (`+` vs `.`)
- Legacy C internals from Zend

> **Note:** While PHP is flawed, **SQL Injection (SQLi)** is not unique to it. The real problem lies in **unsafe string concatenation** rather than language specifics. Always use **parameterized queries**.

---

### Tools & Tactics

#### Regex shortcut for mass renaming:
```bash
%s/<var name/<new var name>/g
```

### Request Smuggling + Hop-by-Hop Headers

More research is being done on **hop-by-hop header exploitation** as apps increasingly rely on proxies. This is seen as the new **bug bounty goldmine**.

---

### WAF & XSS Strategy

When testing XSS behind a strict Web Application Firewall (WAF):

- Try benign payloads first:
```html
<b>test</b>
```
- Use them to check HTML/JS injection viability before escalating.

---

### JSON APIs and CSRF Fallacy

- JSON APIs are not immune to CSRF.
- If the `Content-Type` isn’t validated on endpoints, CSRF may be possible even with JSON bodies.

---

### HTTP Methods Abuse

- Test endpoints with all HTTP methods: `GET`, `POST`, `PUT`, `DELETE`, etc.
- Some applications incorrectly map multiple methods to the same logic.
- `GET` used mutatively is a serious red flag.

---

### Timing Attacks

- Most string comparisons use early exit logic.
- This leaks timing differences that can help infer correct characters.
- Use constant-time comparison functions for:
- Passwords
- Token validation
- HMACs

---

### Automation Experience

- Originally scripted AWS auditing in BASH.
- Rewrote with Python `boto3`.
- Replaced hundreds of lines with a few one-liners.

---

### Bug Bounty Tip: S3 Takeover

- Look for 404’d S3 bucket links in web apps.
- Buckets are globally unique — deleted names can be re-registered.
- This can lead to subdomain takeover and payload injection.

---

### Web Hacking Courses Breakdown

| Course | Good For | Notes |
|----------------|--------------------|----------------------------------|
| OSCP | Generalist | Poor web coverage |
| WAPT | Web fundamentals | Highly recommended |
| WAPTX | Advanced topics | Do WAPT first |
| AWAE | Whitebox testing | Generally not worth it |
| ElearnSecurity | Great balance | Trusted source |

---

### Cybersecurity Foundations 

---

### Networking Deep Dive

- Network Hardware
- TCP/IP & OSI Models
- Architecture (Segmentation, Subnetting, etc.)
- Protocols & Ports
- Security Best Practices

---

### Programming for Security

- **Python** – Scripting, automation, tooling
- **Bash** – Linux admin, pipelines, enumeration
- **PowerShell** – Windows-focused scripting
- **Go** – Fast, portable tools

---

### Operating System Internals

- Terminal navigation & shell basics
- OS structure:
- Kernel, user space
- System calls
- VM setup: Windows & Linux
- Resource management:
- Filesystem
- Processes
- Memory

---

### Windows Environment Security

- [MITRE ATT&CK](https://attack.mitre.org/matrices/enterprise/#)
- [MITRE D3FEND](https://d3fend.mitre.org)
- Blue team tooling for detection and response

---

### Security Concepts

- Firewalls
- IDS/IPS
- Endpoint protection
- Malware basics
- Threat modeling

> Start with CompTIA Security+ objectives for foundational topics.

---

### Cloud & Virtualization

#### Platform Basics

- AWS
- Azure
- Google Cloud

> Useful for:
> - Sandboxing malware
> - Hosting honeypots
> - Creating ephemeral testing environments

#### Suggested Certifications

| Platform | Cert |
|----------|-------------------------------|
| AWS | Certified Cloud Practitioner |
| Azure | Azure Fundamentals |
| GCP | Associate Cloud Engineer |

---
