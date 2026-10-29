# Encoding-Based a–z Alphabets & Cheat‑Sheet

> Curated list for security/research use: diacritics, look‑alike (homoglyph) characters, IDN/Punycode examples, and zero‑width/invisible characters. Not exhaustive.

## 1) Latin Letters with Common Diacritics (a–z)

| Base | Variants (common, not exhaustive) |
|---|---|
| `a` | à á â ã ä å ā ă ą ǻ æ ᵃ |
| `b` | ḃ ɓ ᵇ |
| `c` | ç ć ĉ ċ č ᶜ |
| `d` | ď đ ḋ ḑ ɗ ᵈ |
| `e` | è é ê ë ē ĕ ė ę ě ə ᵉ |
| `f` | ƒ ḟ ᶠ |
| `g` | ĝ ğ ġ ģ ǧ ɡ ᵍ |
| `h` | ĥ ȟ ħ ḥ ḧ ẖ ʰ |
| `i` | ì í î ï ĩ ī ĭ į ı ᶦ |
| `j` | ĵ ǰ ʲ |
| `k` | ķ ĸ ƙ ǩ ᵏ |
| `l` | ĺ ļ ľ ŀ ł ḷ ḹ ᶫ |
| `m` | ḿ ṁ ṃ ᵐ |
| `n` | ñ ń ņ ň ṅ ṇ ꞥ ᶰ |
| `o` | ò ó ô õ ö ō ŏ ő ø œ ǫ ᵒ |
| `p` | ṕ ṗ ƥ ᵖ |
| `q` | ʠ ᑫ |
| `r` | ŕ ŗ ř ṙ ṛ ᵣ ʳ |
| `s` | ś ŝ ş š ṣ ß ẞ ᵴ ᵗˢ |
| `t` | ţ ť ṫ ṭ ƭ ʈ ᵗ |
| `u` | ù ú û ü ũ ū ŭ ů ű ų ᵘ |
| `v` | ṽ ṿ ᵛ |
| `w` | ẁ ŵ ẃ ẅ ẇ ẉ ʷ |
| `x` | ẋ ẍ ˣ |
| `y` | ý ÿ ŷ ȳ ẏ ʸ |
| `z` | ź ż ž ẑ ẓ ᶻ |

## 2) Unicode Homoglyphs (Greek/Cyrillic look‑alikes)

These characters *look like* Latin letters in many fonts but are distinct code points.

| Latin | Confusables (name • char • code point) |
|---|---|
| `A` | Greek Α • `Α` • U+0391<br>Cyrillic А • `А` • U+0410 |
| `a` | Greek α • `α` • U+03B1<br>Cyrillic а • `а` • U+0430 |
| `B` | Greek Β • `Β` • U+0392<br>Cyrillic В • `В` • U+0412 |
| `b` | Cyrillic в • `в` • U+0432<br>Greek β • `β` • U+03B2 (similar) |
| `C` | Cyrillic С • `С` • U+0421 |
| `c` | Cyrillic с • `с` • U+0441 |
| `D` | Cyrillic ԁ • `ԁ` • U+0501 (lowercase shape) |
| `d` | Cyrillic ԁ • `ԁ` • U+0501 (looks like d)<br>Greek ḋ (Latin) • `(Latin)` • — |
| `E` | Greek Ε • `Ε` • U+0395<br>Cyrillic Е • `Е` • U+0415 |
| `e` | Greek ε • `ε` • U+03B5<br>Greek ϵ • `ϵ` • U+03F5<br>Cyrillic е • `е` • U+0435 |
| `f` | Greek ϕ • `ϕ` • U+03D5 (similar)<br>Greek φ • `φ` • U+03C6 (looser) |
| `g` | Cyrillic ɡ (Latin small script g) • `ɡ` • U+0261 |
| `H` | Greek Η • `Η` • U+0397<br>Cyrillic Н • `Н` • U+041D |
| `h` | Cyrillic һ • `һ` • U+04BB<br>Greek η • `η` • U+03B7 (similar)<br>Cyrillic н • `н` • U+043D (uppercase H) |
| `I` | Greek Ι • `Ι` • U+0399<br>Cyrillic І • `І` • U+0406 |
| `i` | Greek ι • `ι` • U+03B9<br>Cyrillic і • `і` • U+0456<br>Cyrillic ї • `ї` • U+0457 |
| `J` | Cyrillic Ј • `Ј` • U+0408 |
| `j` | Cyrillic ј • `ј` • U+0458 |
| `K` | Greek Κ • `Κ` • U+039A<br>Cyrillic К • `К` • U+041A |
| `k` | Greek κ • `κ` • U+03BA<br>Cyrillic к • `к` • U+043A |
| `l` | Cyrillic ӏ • `ӏ` • U+04CF (palochka)<br>Roman numeral ⅰ • `ⅰ` • U+2170 |
| `M` | Greek Μ • `Μ` • U+039C<br>Cyrillic М • `М` • U+041C |
| `m` | Greek μ • `μ` • U+03BC<br>Cyrillic м • `м` • U+043C |
| `n` | Greek ν • `ν` • U+03BD<br>Cyrillic п • `п` • U+043F (looks like n in some fonts) |
| `O` | Greek Ο • `Ο` • U+039F<br>Cyrillic О • `О` • U+041E |
| `o` | Greek ο • `ο` • U+03BF<br>Cyrillic о • `о` • U+043E |
| `P` | Greek Ρ • `Ρ` • U+03A1<br>Cyrillic Р • `Р` • U+0420 |
| `p` | Greek ρ • `ρ` • U+03C1<br>Cyrillic р • `р` • U+0440 |
| `q` | Cyrillic ԛ • `ԛ` • U+051B |
| `r` | Cyrillic г • `г` • U+0433 (can resemble r in some fonts)<br>Cyrillic ґ • `ґ` • U+0491 |
| `s` | Greek ς • `ς` • U+03C2 (final sigma)<br>Greek σ • `σ` • U+03C3<br>Cyrillic ѕ • `ѕ` • U+0455 |
| `T` | Greek Τ • `Τ` • U+03A4<br>Cyrillic Т • `Т` • U+0422 |
| `t` | Greek τ • `τ` • U+03C4<br>Cyrillic т • `т` • U+0442 |
| `u` | Cyrillic υ (Greek upsilon) • `υ` • U+03C5 (looks like u)<br>Cyrillic ц • `ц` • U+0446 (loose) |
| `v` | Greek ν • `ν` • U+03BD (can resemble v)<br>Cyrillic у • `у` • U+0443 (looks like y/v) |
| `w` | Cyrillic ш • `ш` • U+0448<br>Cyrillic щ • `щ` • U+0449 |
| `X` | Greek Χ • `Χ` • U+03A7<br>Cyrillic Х • `Х` • U+0425 |
| `x` | Greek χ • `χ` • U+03C7<br>Cyrillic х • `х` • U+0445 |
| `Y` | Greek Υ • `Υ` • U+03A5 |
| `y` | Greek γ • `γ` • U+03B3 (can resemble y)<br>Cyrillic у • `у` • U+0443 |
| `z` | Cyrillic з • `з` • U+0437<br>Greek ζ • `ζ` • U+03B6 |

## 3) Punycode / IDN Examples

Encoding of non‑ASCII labels and simple domains using IDNA.

| Unicode Label | IDNA (xn--) | Example Domain | IDNA Domain | Code Points |
|---|---|---|---|---|
| `á` | `xn--1ca` | `á.com` | `xn--1ca.com` | U+00E1 |
| `é` | `xn--9ca` | `é.com` | `xn--9ca.com` | U+00E9 |
| `í` | `xn--eda` | `í.com` | `xn--eda.com` | U+00ED |
| `ó` | `xn--kda` | `ó.com` | `xn--kda.com` | U+00F3 |
| `ú` | `xn--rda` | `ú.com` | `xn--rda.com` | U+00FA |
| `ü` | `xn--tda` | `ü.com` | `xn--tda.com` | U+00FC |
| `ñ` | `xn--ida` | `ñ.com` | `xn--ida.com` | U+00F1 |
| `ç` | `xn--7ca` | `ç.com` | `xn--7ca.com` | U+00E7 |
| `ß` | `ss` | `ß.com` | `ss.com` | U+00DF |
| `ø` | `xn--pda` | `ø.com` | `xn--pda.com` | U+00F8 |
| `œ` | `xn--bga` | `œ.com` | `xn--bga.com` | U+0153 |
| `å` | `xn--5ca` | `å.com` | `xn--5ca.com` | U+00E5 |

## 4) Zero‑Width / Invisible Characters

These characters may be invisible or formatting‑only. The brackets below make them visible in context.

| Name | Char in Brackets | Code Point | Notes |
|---|---|---|---|
| ZERO WIDTH SPACE | `[​]` | U+200B | `U+200B` |
| ZERO WIDTH NON-JOINER | `[‌]` | U+200C | `U+200C` |
| ZERO WIDTH JOINER | `[‍]` | U+200D | `U+200D` |
| ZERO WIDTH NO-BREAK SPACE (BOM) | `[﻿]` | U+FEFF | `U+FEFF` |
| SOFT HYPHEN | `[­]` | U+00AD | `U+00AD` |
| WORD JOINER | `[⁠]` | U+2060 | `U+2060` |
| LEFT-TO-RIGHT MARK | `[‎]` | U+200E | `U+200E` |
| RIGHT-TO-LEFT MARK | `[‏]` | U+200F | `U+200F` |
| LEFT-TO-RIGHT EMBEDDING | `[‪]` | U+202A | `U+202A` |
| RIGHT-TO-LEFT EMBEDDING | `[‫]` | U+202B | `U+202B` |
| POP DIRECTIONAL FORMATTING | `[‬]` | U+202C | `U+202C` |
| LEFT-TO-RIGHT ISOLATE | `[⁦]` | U+2066 | `U+2066` |
| RIGHT-TO-LEFT ISOLATE | `[⁧]` | U+2067 | `U+2067` |
| FIRST STRONG ISOLATE | `[⁨]` | U+2068 | `U+2068` |
| POP DIRECTIONAL ISOLATE | `[⁩]` | U+2069 | `U+2069` |

---

_Tip: To reveal invisibles, render code points or replace them with visible placeholders during normalization (NFD/NFKD) and filtering._
