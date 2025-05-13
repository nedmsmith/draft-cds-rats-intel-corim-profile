---
title: Intel Profile for Remote Attestation
abbrev: "Intel profile"
category: info

docname: draft-cds-rats-intel-corim-profile-latest
submissiontype: IETF  # also: "independent", "IAB", or "IRTF"
number:
date:
consensus: true
v: 3
area: "Security"
workgroup: "Remote ATtestation ProcedureS"
keyword:
 - attestation
 - profile
 - corim
venue:
  group: "Remote ATtestation ProcedureS"
  type: "Working Group"
  mail: "rats@ietf.org"
  arch: "https://mailarchive.ietf.org/arch/browse/rats/"
  github: "nedmsmith/draft-cds-rats-intel-corim-profile"
  latest: "https://nedmsmith.github.io/draft-cds-rats-intel-corim-profile/draft-cds-rats-intel-corim-profile.html"

stand_alone: yes
pi:
  rfcedstyle: yes
  toc: yes
  tocindent: yes
  sortrefs: yes
  symrefs: yes
  strict: yes
  comments: yes
  text-list-symbols: -o*+
  docmapping: yes

author:
- ins: J. Beaney
  fullname: James D. Beaney
  organization: Intel Corporation
  email: james.d.beaney@intel.com
- ins: Y. Deshpande
  fullname: Yogesh Deshpande
  organization: ARM Corporation
  email: yogesh.deshpande@arm.com
- ins: A. Draper
  fullname: Andrew Draper
  organization: Altera Corporation
  email: andrew.draper@altera.com
- ins: V. Scarlata
  fullname: Vincent R. Scarlata
  organization: Intel Corporation
  email: vincent.r.scarlata@intel.com
- ins: N. Smith
  fullname: Ned Smith
  organization: Intel Corporation
  email: ned.smith@intel.com

normative:
  I-D.ietf-rats-corim: corim
  DICE.CoRIM:
    -: dice-corim
    title: DICE Endorsement Architecture for Devices
    author:
      org: Trusted Computing Group (TCG)
    seriesinfo: Version 1.0, Revision 0.38
    date: November 2022
    target: https://trustedcomputinggroup.org/wp-content/uploads/TCG-Endorsement-Architecture-for-Devices-V1-R38_pub.pdf
  DICE.Attest:
    -: dice-attest
    title: DICE Attestation Architecture
    author:
      org: Trusted Computing Group (TCG)
    seriesinfo: Version 1.1, Revision 18
    date: January 2024
    target: https://trustedcomputinggroup.org/wp-content/uploads/DICE-Attestation-Architecture-Version-1.1-Revision-18_pub.pdf
  DICE.layer:
    -: dice-layer
    title: DICE Layering Architecture
    author:
      org: Trusted Computing Group (TCG)
    seriesinfo: Version 1.0, Revision 0.19
    date: July 2020
    target: https://trustedcomputinggroup.org/wp-content/uploads/DICE-Layering-Architecture-r19_pub.pdf
  TCG.CE:
    -: tcg-ce
    title: TCG DICE Concise Evidence Binding for SPDM
    author:
      org: Trusted Computing Group (TCG)
    seriesinfo: Version 1.0, Revision 0.54
    date: January 2024
    target: https://trustedcomputinggroup.org/wp-content/uploads/TCG-DICE-Concise-Evidence-Binding-for-SPDM-Version-1.0-Revision-54_pub.pdf
  I-D.ietf-rats-msg-wrap: cmw
  I-D.ietf-rats-eat: eat
  RFC9581: rfc9581

informative:
  RFC9334: rats-arch
  RFC5280: x509
  RFC8392: cwt
  RFC8610: cddl
  I-D.ietf-rats-ar4si: ar4si
  DMTF.SPDM:
    -: spdm
    title: Security Protocol and Data Mmodel (SPDM) Specification
    author:
      org: Distributed Managability Task Force (DMTF)
    seriesinfo: Version 1.2.1
    date: May 2022
    target: https://www.dmtf.org/sites/default/files/standards/documents/DSP0274_1.2.1.pdf
  DICE.engine:
    -: dice
    title: Requirements for a Device Identifier Composition Engine
    author:
      org: Trusted Computing Group (TCG)
    seriesinfo: Family "2.0", Level 00 Revision 78
    date: March 2018
    target: https://trustedcomputinggroup.org/wp-content/uploads/Hardware-Requirements-for-Device-Identifier-Composition-Engine-r78_For-Publication.pdf
  I-D.kdyxy-rats-tdx-eat-profile: tdx-eat-profile
  I-D.ietf-rats-endorsements: rats-endorsements
  INTEL.DCAP:
    -: dcap
    title: Intel(R) Software Guard Extensions (Intel(R) SGX) Data Center Attestation Primitives ECDSA Quote Library API
    author:
      org: Intel Corporation
    date: August 2023
    target: https://download.01.org/intel-sgx/latest/dcap-latest/linux/docs/Intel_SGX_ECDSA_QuoteLibReference_DCAP_API.pdf

entity:
  SELF: "RFCthis"

--- abstract

This document is a profile of various IETF and TCG standards that support remote attestation.
The profile supports Intel-specific adaptations and extensions for Evidence, Endorsements and Reference Values.
This profile describes apticulareplication of CoRIM, EAT, CMW, TCG concise evidence, and TCG DICE specifications.
In particular, CoRIM is extended to define measurement types that are unique to Intel and defines Reference Values types that support matching Evidence based on range and subset comparison.
Multiple Evidence formats are anticipated, based on IETF and TCG specifications.
Evidence formats are mapped to Reference Values expressions based on CoRIM and CoRIM extensions found in this profile.
The Evidence to Reference Values mappings are either documented by industry specifications or by this profile.
Reference Value Providers and Endorsers may use this profile to author mainifests containing Reference Values and Endorsements that require Intel profile support from parser implementations.
Parser implementations can recognize the Intel profile by profile identifier values contained within attestation conceptual mmessages and from profile parameters to media types or profile specific content format identifiers.

--- middle

# Introduction {#sec-introduction}

This profile describes extensions and restrictions placed on Reference Values, Endorsements, and Evidence
that support attestation capabilities of Intel products containing Intel(R) SGX(TM) or Intel(R) TDX(TM) technology, or Intel(R) products that contain
DICE {{-dice}} root of trust, DICE layers {{-dice-layer}}, or modules that implement SPDM {{-spdm}}.

The CoRIM specifications {{-dice-corim}} and {{-corim}} define a baseline schema for Reference Values and Endorsements that are the basis for the extensions defined by this profile.
CoRIM is also a baseline for Evidence
(as specified by DiceTcbInfo {{-dice-attest}}, concise evidence (CoEV) {{-tcg-ce}}, and Security Protocol and Data Model (SPDM) {{-spdm}}).
Having a common baseline schema for Reference Values, Endorsements, and Evidence helps ensure compatibility across a  spectrum of implementations.

This profile defines extensions to CoRIM that support appraisal matching that is not strictly exact-match. For example it defines _sets_, _masks_, _time_, and _ranges_.

The baseline CoRIM, as defined by {{-dice-corim}} is a subset of the Intel profile.
Intel products that implement exclusively the baseline CoRIM do not need this profile.
Implementations based on the Intel profile do not necessarily imply an association with Intel products.

This profile extends CoMID `measurement-values-map`, as defined by {{-dice-corim}} (see also {{-corim}}), with measurement types that are unique to Intel products.
Some measurement types are specific to Reference Values where multiple reference states may be included in reference manifests.
Intel profile extensions use a CBOR tagged value that defines a comparison operator and operands that instruct Verifiers regarding subset, range, and masked values matching semantics.
For example, a numeric operator 'greater-than' instructs the Verifier to match a numeric Evidence value if it is greater than a numeric range operand.

This profile follows the Verifier behavior defined by {{-dice-corim}} and extends Verifier behavior to include operator-operand matching.
If no operator is specified by Reference Values statements, the Verifier defaults to baseline {{-dice-corim}} matching semantics.
If Evidence matches Reference Values and Endorsements apply, Endorsed Values may be added to the accetped claims set.
When all Evidence and Endorsements are processed, the Verifier's set of accepted claims is available for Attestation Results computations.
This profile doesn't define Attestation Results.
Rather, an Attestation Results profile, such as {{-tdx-eat-profile}} may be referenced instead.

This profile is compatible with multiple Evidence formats, as defined by {{-dice-attest}}, {{-tcg-ce}}, and {{-spdm}}.
It describes considerations when mapping Evidence formats to CoRIM {{-dice-corim}} that a Verifier may use when performig appraisals.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

The reader is assumed to be familiar with the terms defined in Section 4 of {{-rats-arch}} and {{-rats-endorsements}}.

# Background {#sec-background}

Complex platforms may contain a variety of hardware components, several of which may contain a hardware root of trust.
Each root of trust may anchor one or more layers {{-dice-layer}} resulting in multiple instances of attestation Evidence.
Evidence may be integrity protected by digital signatures, such as certificates {{-dice-attest}}, tokens {{-cwt}} or by a secure transport {{-spdm}}.
For example, a system bus may allow dynamically configured peripheral devices that have attestation capabilities.
Confidential computing environments, such as SGX, may extend an initial boundary to include a peripheral, or a peer enclave, that together forms a network of trustworthy nodes that a remote
attestation Verifier may need to appraise.
Multiple Evidence blocks may be combined into a composite Evidence block {{-cmw}} that is more easily conveyed.
Complex platforms may have one or more lead Attester endpoints that communicate with a remote Verifier to convey composite Evidence.
The composition of the complex platform is partially represented in the composite Evidence.

However, composite Evidence may not fully describe platform composition.
A complex platform may consist of multiple subsystems, such as network adapters, storage controllers, memory controllers, special purpose processors, etc.
The various sub-subsystem components vendors may create hardware bills of material (HBOM) that describe sub-system composition.
A complex platform vendor may assemble various sub-system components whose composition is described by a platform HBOM.
Although CoRIM may be used to create HBOMs, use of this profile for HBOM creation is unanticipated.

Nevertheless, a complex system may contain multiple identical instances of sub-sytem components that produce identical Evidence blocks.
Additionally, dynamic insertion or removal of a component may result in composite Evidence blocks that reflect this dynamism.

# Profile Identifier {#sec-profile-identifier}

This profile applies to Reference Values from a CoRIM manifest that a Verifier uses to process Evidence.

Profile identifier structures are defined by CoRIM {{-corim}}, EAT {{-eat}} and Concise Evidence (CoEV) {{-tcg-ce}}.

## Intel Profile {#sec-intel-profile}

The profile identifier for the Intel Profile is the OID:

`{joint-iso-itu-t(2) country(16) us(840) organization(1) intel(113741) (1) intel-comid(16) profile(1)}`

`2.16.840.1.113741.1.16.1`

## Media Types, Content Formats, and CBOR Tags

This profile utilizes and/or defines the following media types:

* "application/eat+cwt"
* "application/eat+cwt;eat_profile=2.16.840.1.113741.1.16.1"
* "application/rim+cbor"
* "application/rim+cbor";profile=2.16.840.1.113741.1.16.1"
* "application/toc+cbor"
* "application/toc+cbor;profile=2.16.840.1.113741.1.16.1"
* "application/ce+cbor"
* "application/ce+cbor;profile=2.16.840.1.113741.1.16.1"

This profile utilizes and/or defines the following content format identifiers (C-F ID):

| Content Format                                               | C-F ID | TN Function |
| ------------------------------------------------------------ | ------ | ----------- |
| "application/eat+cwt"                                        | 263    | 1668547081  |
| "application/eat+cwt;eat_profile=2.16.840.1.113741.1.16.1"   | 10005  | 1668556861  |
| "application/toc+cbor"                                       | 10570  | 1668557428  |
| "application/ce+cbor"                                        | 10571  | 1668557429  |
| "application/toc+cbor;profile=2.16.840.1.113741.1.16.1"      | 10572  | 1668557430  |
| "application/ce+cbor;profile=2.16.840.1.113741.1.16.1"       | 10573  | 1668557431  |

This profile uses the following CBOR tags:

| CBOR Tag  | Description |
| --------- | ----------- |
| 501       | Concise Reference Integrity Manifest - (CoRIM) |
| 570       | Concise Table of Contents - (CoTOC) |
| 571       | Concise Evidence - (CoEv) |
| 60010     | Numeric expression |
| 60020     | Set of digests expression |
| 60021     | Set of strings expression |

# Attester Anatomy

Attesters implement DICE layering using an initial Attesting Environment, also called a Root of Trust (RoT), that collection claims about one or more Target Environments.
A Target Environment may become an Attesting Environment for a subsequent Target Environment, and so forth. There may be more than one RoT in the same Attester.

Attesting Environments generate Evidence by signing collected claims using an Attestation Key. Environments may have other keys besides attestation keys. Keys can be regarded as claims that are collected and reported as Evidence. Keys can also be regarded as Target Environments that have measurements that are specific to the key.

Confidential computing environments are Target Environments that can dynamically request Evidence from an Attesting Environment agent. Such Evidence may also be referred to as a 'Quote'.

Each DICE layer may produce signed Evidence. Evidence formats include both signature and measurements formats.
Signature formats may include a mix of X.509 certificates and EAT CWTs. Evidence measurements formats may include a mix of ASN.1 and CBOR, where ASN.1 uses DiceTcbInfo and related varients and CBOR uses concise evidence, and CMW.
Multiple Evidence blocks may be bundled using CMW collections.

Target Environments (other than cryptographic keys) are primarily identified using OIDs from Intel's OID arc (2.16.840.1.113741).
Keys are identified using key identifiers, public key, or certificate digests as defined by `$crypto-key-type-choice` {{-corim}}.

# Evidence Profile {#sec-evidence-profile}

Evidence may be integrity protected in various ways including: certificates {{-x509}}, SPDM transcript {{-spdm}}, and CBOR web token (CWT) {{-cwt}}.
Evidence contained in a certificate may be encoded using `DiceTcbInfo` and `DiceTcbInfoSeq` {{-dice-attest}}.
Evidence contained in an SPDM payload may be encoded using the SPDM `Measurement Block` {{-spdm}}. Evidence may be formatted as `concise-evidence` {{-tcg-ce}} which may be encapsulated by alias certificates, SPDM Measurement Manifests, or EAT tokens.

The `DiceTcbInfo` and SPDM Evidence formats can be translated to CoMID.
The concise evidence format is native to CoMID.
This profile documents evidence mapping from `DiceTcbInfo` and SPDM `Measurement Block` to CoMID, as defined by {{-dice-corim}}.

The CoMID extensions defined by this profile {{sec-measurement-extensions}} are applied to `concise-evidence` so that
Verifiers that support this profile can consistently apply a common schema across Evidence, Reference Values, and Endorsements.

## Evidence Hierarchy {#sec-evidence-hierarchy}

Evidence hierarchy refers to DICE layering where the platform bootstrap components double as Attesting Environments that collect measurements of the other bootstrap components (as Target Environments) until the quoting agent (e.g., SGX Quoting Enclave (QE), TDX Quoting TD (QTD)) is initialized. Tenant trusted execution environment (TEE) components can be dynamically loaded then request Evidence from its quoting agent.
Quoting agents locally verify then sign measurments using the QTD / QE attestation key.
A hierarchy of Evidence consisting of all the Evidence from a RoT to the tenant environment describes the Attester.

A complex device may have multiple roots of trust, such as {{-dice}}, each contributing an evidence hierarchy that results in
several Evidence "chains", that together, constitute a complete Evidence hierarchy for the Attester device.

The Evidence hierarchy should form a spanning tree that contains all Attester Evidence. All Attesting Environments
within the device produce the spanning tree. CoRIM manifests contain Reference Values for the spanning tree so that
Verifiers do not assume the spanning tree is defined by Evidence.
Note that a failure or comporomise within the Attester device could result in a portion of the spanning tree being omitted.

Evidence examples:

- A DICE certificate chain with a DiceTcbInfo extension, a DiceTcbInfoSeq extension, and a `ConceptualMessageWrapper` (CMW)
{{-cmw}} extension containing a CBOR-encoded `tagged-concise-evidence`.
- An SPDM alias intermediate certification chain containing a CMW extension, and an SPDM measurement manifest containing
`tagged-concise-evidence`.

## Concise Evidence {#sec-concise-evidence}

Concise evidence is a CDDL representation of Evidence {{-tcg-ce}} that uses expressions from CoMID, which are a subset of CoRIM. See {{-dice-corim}} and {{-corim}}.
Evidence describes the actual state of the Attester.
`tagged-concise-evidence` uses a CBOR tag (571) to identify `concise-evidence` {{-tcg-ce}}.
This profile uses `concise-evicence` in conceptual message wrappers {{-cmw}} and EAT tokens {{-eat}} to encode Evidence.
This profile extends `concise-evidence` by extending `measurement-values-map`.

# Reference Values and Endorsements Profile {#sec-refend-profile}

The CoRIM specifications {{-dice-corim}} and {{-corim}} define a baseline schema for Reference Values and Endorsements in this profile.
The profile defines extensions to CoRIM for measurement types that are not representable by CoRIM or are more conveniently represented.
This profile doesn't require use of extensions when base capabilities will suffice.

## Concise Module ID Tag (CoMID) {#sec-comid}

This profile uses `concise-mid-tag` in conceptual message wrappers {{-cmw}} and CoRIMs.
This profile extends `concise-mid-tag` by extending `measurement-values-map`.
Several extensions define two forms, one for representing actual state which is used for Endorsements and Evidence.
The other form is used to represent reference state which is used for Reference Values.

## Raw Value Measurements {#sec-raw-value}

Raw value measurements encode vendor-defined values opaquely.
However, the `mkey` value can add vendor-specific semantics when used with `raw-value` and `name` measurement types.
Additionally, specific `environment-map` values can supply vendor-specific semantics to `raw-value` and `name` measurement types.

Environments that project vendor-specific semantics are as follows:

| Envoronment Identifier  | Value   | Semantics |
|-------------------------|---------|-----------|
| class-id:OID=2.16.840.1.113741.1.5.3.6.8 | 560(bytes) | device type |

# CoRIM Extensions {#sec-comid-extensions}

The Intel Profile extends `measurement-values-map` which is used by Evidence, Reference Values, and Endorsed Values by defining code points from the negative integer range.

Reference Values extensions define types that can have multiple Reference Values that "match" a singleton Evidence value called "non-exact match" matching.
Reference state expressions define non-exact-match matching semantics in terms of numeric ranges, time, sets, and masks.

## Data Types {#sec-data-types}

### Masked Values {#sec-mask}

Masked values are a string of bytes (e.g., `bstr`) that may have a companion mask value.
The mask indicates which bits in the value are ignored when doing bit-wise equivalency comparisons.
Verifier matching applies the equivalency test, allowing dissimilar Evidence and Reference values to be considered equivalent even if the two values (Evidence and Reference) are dissimilar.
Evidence typically does not supply a mask.
A Reference Value may omit the mask if bit-wise equivalency is desired.

The `$masked-value-type` type choice can be either `~tagged-bytes` or `$raw-value-type-choice`.
Evidence might be encoded as `~tagged-bytes` or `tagged-bytes` which omits a mask value,
while Reference Values of type `tagged-masked-raw-value` includes the mask value.

The Verifier MUST ensure the lengths of values and mask are equivalent. If the mask is shorter
than the longest value, the mask is appended with zeros (0) until it is the same length as the longest value, either Evidence or Reference Value.
If the mask is longer than the longest value, the mask is truncated to the length of the longest value.
All values are evaluated from left to right (big-endian) applying bit-wise comparisons.

The masked value data types are as follows:

~~~ cddl
{::include cddl/mask-type.cddl}
~~~

## Expressions {#sec-expressions}

Expressions can be used with Reference Values or Endorsement conditions.
Matching is applied using an operator and operands.
There are two types of operators, numeric: such as greater-than or less-than,
and sets: such as set membership.

Expressions are an array containing an operator followed by zero or more operands.
The operator definition identifies the additional operands and their data types.
A Verifier forms an expression using Evidence as the first operand and obtains the operator from the first entry in
the expression array.

This profile describes operations using *infix* notation where the first operand, *operand_1*, is obtained from Evidence,
followed by the operator, followed by any remaining operands: *operand_2*, *operand_3*..., taken from Reference Values.

Expressions statements are CBOR tagged to indicate the values following the CBOR tag are to be evaluated as an expression equation.
Expression statements found in Reference Values informs the Verifier that Evidence is needed to complete
the expression equation.

Expressions are CBOR tagged to disambiguate the type of expression. See {{sec-iana-considerations}}.

For example:

* `#6.CBOR_Tag([ operator, operand_2, operand_3, ... ])`.

Appraisal processing MUST evaluate expression equations to comply with this profile.

### Expression Operators {#sec-expression-operators}

There are three CBOR tagged operators as follows:

1. **60010**: A `numeric` expression with a numeric operator ({{sec-numeric-expressions}}) followed by a numeric operand: integer, unsigned integer, or floading point.
1. **60020**: A set of digests operator ({{sec-set-expressions}}) followed by a set of digests operand which is an array of `digests`.
1. **60021**: A set of strings operator ({{sec-set-expressions}}) followed by a set of strings operand which is an array of `tstr`.

The position of items in a set is not significant.

#### Equivalence Operator {#sec-equivalance-operator}

By default, *exact* match rules are assumed. Consequently, no operator artifact is needed when
Evidence values are identical to Reference Values.

### Numeric Expressions {#sec-numeric-expressions}

Numeric expressions consist of an Evidence operand (Evidence_Operand) and an array containing a numeric operator and a numeric operand (Reference_Operand).

Numeric operators apply to values that are integers, unsigned integers or floating point numbers.
There are four numeric operators:

1.  **equal** (`op.eq`),
1.  **greater-than** (`op.gt`),
1.  **greater-than-or-equal** (`op.ge`),
1.  **less-than** (`op.lt`),
1.  **less-than-or-equal** (`op.le`).

Equivalence semantics can be achieved without using an expression with the `op.eq` operator by using the same data type for both Evidence and Reference Value.

The numeric operator data type definitions are as follows:

~~~ cddl
{::include cddl/numeric-type.cddl}
~~~

Evidence and Reference Values MUST be the same numeric type. For example, if a Reference Value numeric type is
`integer`, then the Evidence numeric value must also be `integer`.

This profile defines four numeric expressions, one for each numeric operator:

* `tagged-numeric-gt`,
* `tagged-numeric-ge`,
* `tagged-numeric-lt`,
* `tagged-numeric-le`.

In each case, the numeric operator is used to evaluate a Reference Value operand against an Evidence value operand.

The expression is evaluated using *infix* notation where Evidence_Operand is the left-hand-side of the numeric operator and the Reference_Operand is the right-hand-side.

Example:

* The expression: `( 7 `op.le` 9 )` evaluates to TRUE.

The numeric type definition is as follows:

~~~ cddl
{::include cddl/numeric-expr.cddl}
~~~


### Set Expressions {#sec-set-expressions}

Set expressions consist of an Evidence operand (Evidence_Operand) and an array containing a set operator and a set operand (Reference_Set_Operand).

Sets have two operators:

* **op.mem** - operand_1 is a member of the set operand_2.
* **op.nmem** - operand_1 is NOT a member of the set operand_2.

Example:

* The expression: `("fox" `op.mem` [ "cat", "dog", "fox" ])` evaluates to TRUE.

The set type is as follows:

~~~ cddl
{::include cddl/set-type.cddl}
~~~

The set expression array contains a set operator followed by an array of values which are the members of a set of Reference Values.
The set is defined by `set-type`.

The set expression definitions are as follows:

~~~ cddl
{::include cddl/set-expr.cddl}
~~~

The Evidence_Operand MUST NOT be nil.

The Reference_Set_Operand MAY be the empty set - e.g. `[ ]`.

##  Measurement Extensions {#sec-measurement-extensions}

This profile extends the CoMID `measurement-values-map` with additional code point definitions,
that accommodate Intel SGX and similar architectures.
Measurement extensions don't change Verifier behavior. An extension enables the Verifier to validate the profile compliance of the input evidence and reference values, as it defines the acceptable data types in evidence and the expression operator that is explicitly
supplied with the Reference Values, see {{sec-expression-operators}}.

In cases where Evidence does not exactly match Reference Values, the operator definition determines the
expected data types of the operands.
Expected Verifier behavior is defined in {{sec-intel-appraisal-algorithm}}

The measurement extensions that follow are assumed to be appraised according to the appriasal steps described in {{Section 8.1 of -corim}}.

### The tee.advisory-ids Measurement Extension {#sec-tee-advisory-ids-type}

The `tee.advisory-ids` extension enables Attesters to report known security advisories and for
Reference Values Providers (RVP) to assert updated security advisories.
It can also be used by Endorsers to assert security advisory information through conditional endorsement.

The `$tee-advisory-ids-type` is used to specify a set of security advisories, where each identifier is represented using a string.
Evidence may report a set of advisories the Attester believes are relevant. The set of advisories are constrained
by the `set-tstr-type` structure.

As a Reference Value expression, an empty set can be used to signify that no outstanding advisories are expected.
If the Evidence also contains the empty set then the Reference corroborates the Evidence.

The `$tee-advisory-ids-type` is a list of strings, each identifying a single security advisory.
When used with Evidence the `set-tstr-type` type is used.
When used with Reference Values or Endorsements the `set-tstr-type`, `tagged-exp-tstr-member`, or `tagged-exp-tstr-not-member` types can be used.

~~~ cddl
{::include cddl/tee-advisory-ids-type.cddl}
~~~

#### The tee-advisory-ids-type Comparison Algorithm {#sec-tee-advisory-ids-comp}

The comparison algorithm for `tee-advisory-ids-type` is used when Endorsement or Reference Values triples conditions are matched with an Environment Claims Tuple (ECT) in the Verifier's Accepted Claims Set (ACS).
The triple condition containing a `tee-advisory-ids-type` Claim matches an ACS ECT according to the comparison algorithm for set of strings as defined in {{sec-ca-sets}}.

### The tee.attributes Measurement Extension {#sec-tee-attributes-type}

The `tee.attributes` extension enables the Attester to report TEE attributes and an RVP to assert a reference
TEE attributes and mask.

The `$tee-attributes-type` is used to specify TEE attributes in 8 or 16 byte words. If Evidence uses an 8 byte
mask, then the Reference Values expression also uses an 8 byte value and mask.

The `$tee-attributes-type` is a singleton value omitting the mask value when used as Endorsement or Evidence
and a tuple containing the reference and mask when used as a Reference Value.

~~~ cddl
{::include cddl/tee-attributes-type.cddl}
~~~

Alternatively, the TEE attributes may be encoded using `mkey` where `mkey` contains the non-negative `tee.attributes` and `mval`.`raw-value` contains the `$tee-attributes-type`.`mask-type` value.

### The tee.cryptokeys Measurement Extension {#sec-tee-cryptokey-type}

The `tee.cryptokeys` extension identifies cryptographic keys associated with a Target Environment.
If multiple `$crypto-key-type-choice` measurements are supplied, array position disambiguates each entry.
Appraisal compares values indexed by array position.

~~~ cddl
{::include cddl/tee-cryptokey-type.cddl}
~~~

Alternatively, the TEE cryptokeys may be encoded using `mkey` where `mkey` contains the non-negative `tee.cryptokeys` and `mval`.`cryptokeys` contains the `$tee-cryptokey-type` value.

### The tee.tcbdate Measurement Extension {#sec-tee-date-type}

The `tee.tcbdate` (code point -72) extension is used by Endorsers to assert validity of a TEE component.
For example, a conditional endorsement might locate a component based on a few expected Claims, then augment them with a `tee.tcbdate` Claim.

The `$tee-date-type` can be expressed in several ways:

- ISO 8601 strings of the form YYYY-MM-DDTHH:MM:SSZ.

- POSIX time which is the number of seconds since January 1, 1970 (midnight UTC).

- RFC9581 etime {{-rfc9581}}.

~~~ cddl
{::include cddl/tee-date-type.cddl}
~~~

`~tdate` strings must be converted to a numeric value (i.e.,`~time`) before operations involving time are applied.

Alternatively, `tee.tcbdate` may be encoded using `mkey` where `mkey` contains the non-negative code point value and where `mval`.`name` contains the string representation `$tee-date-type` without the CBOR tag (i.e., ~tdate - see Section 3.7 {{-cddl}}).

### The tee.mrtee and tee.mrsigner Measurement Extension {#sec-tee-digest-type}

The `tee.mrtee` extension enables an Attester to report digests for the SGX enclave or TDX TD (e.g., MRENCLAVE, MRTD).
The `tee.mrsigner` extension enables an Attester to report the signer of the TEE digest (e.g., MRSIGNER).

The `$tee-digest-type` has multiple type structures involving digest values. A singleton digest has a hash algorithm identifier and the digest value.
When used as Evidence, either a signleton digest or a set of digests can be reported.
When used as Reference Values or Endorsements, a set of digests can be asserted signifying equivalence matching.
Alternatively, matching may be expressed as set membership or set difference expressions.

~~~ cddl
{::include cddl/tee-digest-type.cddl}
~~~

Alternatively, the TEE digests may be encoded using `mkey` where `mkey` contains the non-negative `tee.mrtee` or `tee.mrsigner` and `mval`.`digests` contains a `digests-type` value.

#### The tee-digest-type Comparison Algorithm {#sec-tee-digest-comp}

The comparison algorithm for `tee-digest-type` is used when the condition statement in an Endorsement or Reference Values triple is matched with an Environment Claim Tuple (ECT) from the Verifier's Accepted Claims Set (ACS).
The comparison algorithm for set of digests is defined in {{sec-ca-sets}}.

### The tee.platform-instance-id Measurement Extension {#sec-tee-platform-instance-id-type}

Platform Instance ID is a globally unique identifier generated by the platform during Platform Establishment. This value remains consistent across trusted computing base (TCB) recoveries, but is regenerated during Platform Establishment due to desire to reset keys or to add and remove hardware. See (Section 3.7 {{-dcap}}).

The `tee.platform-instance-id` extension enables the Attester to report the platform instance identifier as an Evidence value and the RVP to assert an exact-match Reference Value.

The `$tee-platform-instance-id-type` is a `bstr`.

~~~ cddl
{::include cddl/tee-platform-instance-id-type.cddl}
~~~

Alternatively, the platform instance ID may be encoded using `mkey` where `mkey` contains the non-negative `tee.platform-instance-id` code point and `mval`.`raw-value` contains the `$tee-platform-instance-id-type` value.

### The tee.isvprodid Measurement Extension {#sec-tee-isvprodid-type}

The `tee.isvprodid` extension enables the Attester to report the ISV product identifier Evidence value
and the RVP to assert an exact-match Reference Value.

The `$tee-isvprodid-type` is an unsigned integer.

The `$tee-isvprodid-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-isvprodid-type.cddl}
~~~

Alternatively, the TEE product ID may be encoded using `mkey` where `mkey` contains the non-negative `tee.isvprodid` and `mval`.`raw-value` contains the `$tee-isvprodid-type` value.

### The tee.miscselect Measurement Extension {#sec-tee-miscselect-type}

The `tee.miscselect` extension enables the Attester to report the (TBD:miscselect-description) Evidence value
and the RVP to assert a Reference Value and mask.

The `$tee-miscselect-type` is a 4 byte value and mask.

The `$tee-miscselect-type` is a singleton `mask-type` value when used as Endorsement or Evidence
and a `tagged-masked-raw-value` when used a Reference Value.

~~~ cddl
{::include cddl/tee-miscselect-type.cddl}
~~~

Alternatively, the TEE miscselect may be encoded using `mkey` where `mkey` contains the non-negative `tee.miscselect` and `mval`.`raw-value` contains the measurement value and `mval`.raw-value-mask` contains the mask value.

### The tee.model Measurement Extension {#sec-tee-model-type}

The `tee.model` extension enables the Attester to report the TEE model string as Evidence
and the RVP to assert an exact-match Reference Value.

The `$tee-model-type` is a string.

The `$tee-model-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-model-type.cddl}
~~~

Alternatively, the TEE model may be encoded using `mkey` where `mkey` contains the non-negative `tee.model` and `mval`.`name` contains the `$tee-model-type` value.

### The tee.pceid Measurement Extension {#sec-tee-pceid-type}

The `tee.pceid` extension enables the Attester to report the PCEID as Evidence and the RVP to assert an exact-match Reference Value.

The `$tee-pceid-type` is a string or a uint. As string, PCEID is a four character decimal value such as "0000".

The `$tee-pceid-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-pceid-type.cddl}
~~~

Alternatively, the PCEID may be encoded using `mkey` where `mkey` contains the non-negative `tee.pceid` and `mval`.`name` (code point 11) contains the string representation.
Or, `mval`.`raw-int` (code point 15) contains the integer representation.

### The tee.isvsvn Measurement Extension {#sec-tee-svn-type}

The `tee.isvsvn` extension enables the Attester to report the SVN for the independent software vendor supplied
component as Evidence and the RVP to assert a Reference Value that is greater-than-or-equal to the reported SVN.

The `$tee-svn-type` is either an unsigned integer when reported as Evidence, or a tagged numeric expression
that contains an SVN and a numeric greater-than-or-equal operator. The Verifier ensures the Evidence value is greater-that-or-equal to the Reference Value.

The `$tee-svn-type` is a `svn-type` when used as Endorsement or Evidence and a `tagged-numeric-expression` when used as a Reference Value.

~~~ cddl
{::include cddl/tee-svn-type.cddl}
~~~

Alternatively, the TEE isvsvn may be encoded using `mkey` where `mkey` contains the non-negative `tee.isvsvn` and `mval`.`svn` contains the svn value as `svn-type`.

### The tee.tcb-comp-svn Measurement Extension {#sec-tee-tcb-comp-svn-type}

The `tee.tcb-comp-svn` extension enables the Attester to report an array of SVN values for the TCB when asserted
as Evidence and an array of `tagged-numeric-ge` entries when asserted as a Reference Value.

The `$tee-tcb-comp-svn-type` is an array containing 16 SVN values when reported as Evidence and an array of 16
expression records each containing the numeric `ge` operator and a reference SVN value.
The Verifier evaluates each SVN in the Evidence array with the corresponding reference expression,
by array position.
If all Evidence values match their respective expressions, evaluation is successful.
The array of SVN Evidence is accepted.

~~~ cddl
{::include cddl/tee-tcb-comp-svn-type.cddl}
~~~

### The tee.tcb-eval-num Measurement Extension {#sec-tee-tcb-eval-num-type}

The `tee.tcb-eval-num` extension enables the Attester to report a TCB evaluation number as Evidence and the RVP to assert a Reference Value expression that compares the tcb-eval-num Evidence with the Reference Value using the greater-than-or-equal operator.

The `$tee-tcb-eval-num-type` is an unsigned integer when reported as Evidence and a tagged numeric expression when asserted as Reference Values.

~~~ cddl
{::include cddl/tee-tcb-eval-num-type.cddl}
~~~

Alternatively, the TEE tcb-eval-num Evidence may be encoded using `mkey` where `mkey` contains the non-negative `tee.tcb-eval-num` and `mval`.`raw-value` contains the tcb-eval-num encoded as 4-byte bstr value.

### The tee.tcb-status Measurement Extension {#sec-tee-tcbstatus-type}

The `tee.tcb-status` extension enables Attesters to report the status of the TEE trusted computing base (TCB)
and for Reference Value Providers (RVP) to assert expected TCB status.
It can also be used by Endorsers to assert TCB status through conditional endorsement.

The `tee-tcbstatus-type` is used to specify TCB status as a set of status strings or as an expression with a set membership operator.

The `$tee-tcbstatus-type` is a status array containing strings describing TCB status values.
When describing Evidence the `set-tstr-type` type is used.
When describing Reference Values or Endorsements the `set-tstr-type`, `tagged-exp-tstr-member`, or `tagged-exp-tstr-not-member` types can be used.

~~~ cddl
{::include cddl/tee-tcbstatus-type.cddl}
~~~

#### The tee-tcbstatus-type Comparison Algorithm {#sec-tee-tcbstatus-comp}

The comparison algorithm for `tee-tcbstatus-type` is used when Endorsement or Reference Values triples conditions are matched with an Environment Claims Tuple (ECT) in the Verifier's Accepted Claims Set (ACS).
The triple condition containing a `tee-tcbstatuss-type` Claim matches an ACS ECT according to the comparison algorithm for set of strings as defined in {{sec-ca-sets}}.

### The tee.vendor Measurement Extension {#sec-tee-vendor-type}

The `tee.vendor` extension enables the Attester to report the TEE vendor name as Evidence and for the RVP to assert
the TEE vendor name.

The `$tee-vendor-type` is a string containing the vendor name as a string. The vendor string in Evidence must
exactly match the vendor string in Reference Values.

The `$tee-vendor-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-vendor-type.cddl}
~~~

Alternatively, the TEE vendor may be encoded using `mkey` where `mkey` contains the non-negative `tee.vendor` and `mval`.`name` contains the `$tee-vendor-type` value.

# Appraisal Algorithm {#sec-intel-appraisal-algorithm}

The Intel profile anticipates appraisal algorithms will be based on the appraisal algorithm defined in {{-corim}}.
This profile extends the appraisal algorithm to recognize profile extensions that form equations.
An Evidence measurement forms one of the operands: (evidence operand).
A Reference Value forms the operator and remaining operands:

* \[expression operator, reference value operand, etc...\]

For example, if a numeric Reference Value is 14, and the expressions operator is `gt` the Reference Value might contain the Claim: `#6.60010([ 1, 14])`.
Given Evidence contains the value: 15.
The in-fix construction of the equation would be: `15 gt 14`.
The Verifier evaluates whether `15` is greater-than `14`.

## Complex Expressions {#sec-complex-expressions}

Complex expressions can be used to assess whether the Target Environment is in a particular state before certain Endorsement claims can be asserted.
For example, if an SGX enclave has an `svn` value that is less than the prescribed minimum svn, the enclave status may be
considered "OutOfDate" or may have a known security advisory. The CoMID `conditional-endorsement-triples` or
`conditional-endorsement-series-triples` describe complex Endorsement expressions.

This profile uses these triples with the reference measurement values extensions described in {{sec-measurement-extensions}}.

## Comparison Algorithm for Sets {#sec-ca-sets}

The comparison algorithm for sets describes set equivalence, set membership, and set difference (not membership).
The Verifier's Accepted Claims Set (ACS) contains a list of Environment Claims Tuples (ECT){{-corim}}.
The condition ECTs are compared to ACS ECTs based on this comparison algorithm.

The set comparison algorithm processes sets of strings and sets of digests.

### Comparison Algorithm for Set of Strings {#sec-ca-stringsets}

There are three string set representations: `set-tstr-type`, `tagged-exp-tstr-member`, and `tagged-exp-tstr-not-member`.

* `set-tstr-type` - Every string in the condition `set-tstr-type` MUST match a string in the ACS.ECT.`element-map`.`element-claims`.`set-tstr-type` set.
The string position in the array is not significant.
The ACS.ECT.`element-map`.`element-claims`.`set-tstr-type` set MUST be equivalent to the condition `set-tstr-type` set (i.e., the two sets have the same cardinality and the same set members).

* `tagged-exp-tstr-member` - The condition ECT set operator MUST equal `member` and every string in the condition `set-tstr-type` MUST match a string in the ACS.ECT.`element-map`.`element-claims`.`set-tstr-type` set.
The string position in the array is not significant.
The ACS.ECT.`element-map`.`element-claims`.`set-tstr-type` set MAY contain strings not found in the condition `set-tstr-type`.

* `tagged-exp-tstr-not-member` - The condition ECT set operator MUST equal `not-member` and every string in the condition `set-tstr-type` MUST NOT match a string in the ACS.ECT.`element-map`.`element-claims`.`set-tstr-type` set.
The string position in the array is not significant.

### Comparison Algorithm for Set of Digests {#sec-ca-digestsets}

There are five digest set representations: `digest`, `digest-type`, `set-digest-type`, `tagged-exp-digest-member`, and `tagged-exp-digest-not-member`.

* `digest` - The singleton `digest` in the condition MUST match at least one digest in the ACS.ECT.`element-map`.`element-claims`.`set-digest-type` set.

* `digest-type` and `set-digest-type` - Every digest in the condition `digest-type` or `set-digest-type` MUST match a digest in the ACS.ECT.`element-map`.`element-claims`.`set-digest-type` set.
The digest position in the array is not significant.
The ACS.ECT.`element-map`.`element-claims`.`set-digest-type` set MUST be equivalent to the condition `set-digest-type` set (i.e., the two sets have the same cardinality and the same set members).
Matching based on the empty set is permitted when the `set-digest-type` is used.

* `tagged-exp-digest-member` - The condition ECT set operator MUST equal `member` and every digest in the condition `set-digest-type` MUST match a digest in the ACS.ECT.`element-map`.`element-claims`.`set-digest-type` set.
The digest position in the array is not significant.
The ACS.ECT.`element-map`.`element-claims`.`set-digest-type` set MAY contain digests not found in the condition `set-digest-type`.

* `tagged-exp-digest-not-member` - The condition ECT set operator MUST equal `not-member` and every digest in the condition `set-digest-type` MUST NOT match a digest in the ACS.ECT.`element-map`.`element-claims`.`set-digest-type` set.
The digest position in the array is not significant.

# Reporting Attestation Results {#sec-intel-reporting-attestation-results}

Attestation verification can be performed by a pipeline consisting of multiple stages where each input manifest demarks a stage.
The final stage prepares Attestation Results according to Relying Party specifications.
This profile does not define an attestation results format.
The Relying Party should specify suitable Attestation Results formats such as {{-ar4si}} or {{-tdx-eat-profile}}.

The precise Attestation Results format used, if negotiated by Verifier and Relying Party, should reference this profile to acknowledge
that the Relying Party and Verifier both support the extensions defined in this document.

# Security Considerations {#sec-security-considerations}

The security of this profile depends on the security considerations of the various normative references.

# IANA Considerations {#sec-iana-considerations}

IANA has allocated the following tags in the CBOR Tags registry {{!IANA.cbor-tags}}.

|    Tag #  | Data Item   | Semantics                                               | Reference |
| -------   | ---------   | ---------                                               | --------- |
| 60010 | array | Contains a numeric expression, see {{sec-numeric-expressions}}    | {{&SELF}} |
| 60020 | array | Contains a set of digest expression, see  {{sec-set-expressions}} | {{&SELF}} |
| 60021 | array | Contains a set of tstr expression, see  {{sec-set-expressions}}   | {{&SELF}} |


{: #tbl-iana-intel-profile-reg-items title="Intel Profile Tag Registration Code Points"}

--- back

# Acknowledgments

The authors wish to thank Shanwei Cen, Piotr Zmijewski, Francisco J. Chinchilla and Dionna Amalie Glaze for their valuable contributions.

# Full Intel Profile CDDL

~~~ cddl
{::include cddl/exports/intel-profile.cddl}
~~~


