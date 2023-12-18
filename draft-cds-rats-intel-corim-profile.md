---
title: Intel Profile for CoRIM
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
 -  ins: J. Beaney
    fullname: James D. Beaney
    organization: Intel Corporation
    email: james.d.beaney@intel.com
 -  ins: A. Draper
    fullname: Andrew Draper
    organization: Intel Corporation
    email: andrew.draper@intel.com
-  ins: V. Scarlata
    fullname: Vincent R. Scarlata
    organization: Intel Corporation
    email: vincent.r.scarlata@intel.com
-  ins: N. Smith
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
    seriesinfo: Version 1.00, Revision 0.23
    date: March 2021
    target: https://trustedcomputinggroup.org/wp-content/uploads/DICE-Attestation-Architecture-r23-final.pdf
  DICE.layer:
    -: dice-layer
    title: DICE Layering Architecture
    author:
      org: Trusted Computing Group (TCG)
    seriesinfo: Version 1.0, Revision 0.19
    date: July 2020
    target: https://trustedcomputinggroup.org/wp-content/uploads/DICE-Layering-Architecture-r19_pub.pdf
  TCG.concise-evidence:
    -: tcg-ce
    title: TCG DICE Concise Evidence Binding for SPDM
    author:
      org: Trusted Computing Group (TCG)
    seriesinfo: Version 1.0, Revision 0.53
    date: June 2023
  I-D.ftbs-rats-msg-wrap: cmw
  I-D.ietf-sacm-coswid: coswid
  IANA.CBOR:
   -: iana-cbor
   title: Concise Binary Object Representation (CBOR) Tags
   author:
     org: Internet Assigned Numbers Authority (IANA)
   date: September 2013
   target: https://www.iana.org/assignments/cbor-tags/cbor-tags.xhtml

informative:
  RFC9334: rats-arch
  RFC5280: x509
  RFC8392: cwt
  I-D.birkholz-rats-epoch-markers: epoch-markers
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

--- abstract

This document describes extensions to the CoRIM schema that support Intel specific Attester implementations.
Multiple Evidence formats are compatible with base CoRIM, but extensions to evidence formats may be required to
fully support the CoMID schema extensions defined in this profile.
The concise evidence definition uses the CoMID schema such that extensions to CoMID are inherited by concise evidence.
Reference Value Providers may use this profile to author mainifests containing Reference Values and Endorsements.
RATS Verifiers recognize this profile by it's profile identifier and implement support for the extentions defined.

--- middle

# Introduction {#sec-introduction}

This profile describes extensions and restrictions placed on Reference Values, Endorsements, and Evidence
that support attestation capabilities of Intel products including Intel(R) SGX(TM), and products that contain
a DICE {{-dice}} root of trust, DICE layers {{-dice-layer}}, or modules that implement SPDM {{-spdm}} endpoints.

The CoMID schema {{-dice-corim}} and data model {{-corim}} is a baseline for Reference Values that expects Evidence is matched
using values that are identical. This profile anticipates Reference Values that are a set or range of values where an Evidence
value is within the reference set or range. This document describes schema and data model extensions for matching based on
membership in a set, masked values, and numeric ranges.

The baseline CoRIM schema defines a spartan set of measurement values that are etended by this profile to better support Intel(r) products.
However, the defined extensions may be generally useful such that implementation of the Intel profile need not imply the
Attester, Verifier, Relying Party, Reference Value Provider, or Endorser must be Intel products.

This profile extends CoMID schema `measurement-values-map`, as defined by {{-corim}}, with measurements that may be unique to
Intel products or are not defined anywhere else. Some measurement definitions are specific to Reference Values such that multiple
Reference Values may be specified and an operator instructs Verifiers regarding the matching algorithm to apply. For example,
a numeric operator 'greater-than' instructs the Verifier to match a numeric Evidence value if it is greater than
one or more numeric Reference Values.

This profile follows the Verifier behavior defined by {{-corim}} and extends Verifier behavior to include non-exact matching as
indicated by a supplied operator.
If no operator is specified by Reference Value statements, the Verifier defaults to exact matching.
If Evidence matches Reference Values and Endorsements apply, endorsed values are added to the the accetped measurements.
When all Evidence and Endorsements are processed, the Verifier's set of accepted measurements is used to produce Attestation Results.

This profile is compatible with multiple Evidence formats, as defined by {{-dice-attest}} and
SPDM {{-spdm}}. It describes considerations when mapping Evidence formats to CoRIM that a Verifier may use when doing matching.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

The reader is assumed to be familiar with the terms defined in Section 4 of {{-rats-arch}}.

# Background {#sec-background}

Complex platforms may contain a variety of hardware components, several of which may contain a hardware root of trust.
The root of trust may anchor one or more layers {{-dice-layer}} resulting in multiple instances of attestation Evidence.
Evidence may be protected by an wrapping structure, such as a certificate {{-dice-attest}} or a secure transport over a
bus interface {{-spdm}} may provide integrity protection. For example, a system bus may allow dynamically configured
peripheral devices that have attestation capabilities. Confidential computing environments, such as SGX, may extend an
initial boundary to include a peripheral, or a peer enclave, that together forms a network of trustworthy nodes that a remote
attestation Verifier may need to appraise.

Such a complex platform may rely one or more endpoints that communicate with a remote Verifier to convey a structure that
is a conglomeration of Evidence instances. A complex platform may consist of multiple instances of a subsystem, such as multiple
network adapters, storage controllers, or processors. Even though they may be identical copies, each instance should have its
own Evidence instance. Insertion and removal of a configurable component may affect the composition  of Evidence.

# Profile Identifier {#sec-profile-identifier}

This profile applies to Reference Values from a CoRIM manifest that a Verifier uses to process Evidence.

The profile identifier structure is defined by CoRIM as:

~~~ cddl
{::include draft-ietf-rats-corim/cddl/profile-type-choice.cddl}
~~~

The profile identifier for this profile is the OID:

`{joint-iso-itu-t(2) country(16) us(840) organization(1) intel(113741) (1) intel-comid(16) profile(1)}`

`2.16.840.1.113741.1.16.1`

# CoMID Schema Extensions {#sec-comid-schema-extensions}

The baseline CoMID schema for Reference Values is extended with an attribute that informs a Verifier as to which matching
semantics to apply, whether they are equivalance, range, or set membership semantics.

This profile extends `measurement-values-map` with additional measurements that are used by Evidence,
Reference Values, and Endorsed Values.

## Expressions {#sec-expressions}

Expressions are used to specify richer Reference Values measurements that expect non-exact matching semantics.
The Reference Value expression instructs the Verifier regarding matching parameters,
such as greater-than or less-than, ranges, sets, etc. Typically, the Evidence value is one operand of an expression
and the Reference Value contains the operator and additional operands.

The operator and remaining operands are contained in an array.
Expression arrays have an operator followed by zero or more operands.
The operator definition identifies the additional operands and their data types.
A Verifier forms an expression using Evidence as the first operand, obtains the operator from the first entry in
the expression array, and any remaining array entries are operands.

This document describes operations using *infix* notation where the first operand, *operand_1*, is obtained from Evidence,
followed by the operator, followed by any remaining operands: *operand_2*, *operand_3*, etc...

For example:

* From Evidence: `operand_1`, from Reference Values: `[ operator, operand_2, operand_3, ... ]`.

Expression records are CBOR tagged to indicate the following CBOR is to be evaluated as an expression.
Expression statements found in Reference Values informs the Verifier that Evidence is needed to complete
the expression equation. Appraisal processing MUST evaluate the expression.

This profile anticipates use of the CBOR tag `#6.60010` to identify expression arrays. See {{sec-iana-considerations}}

For example:

* `#6.60010([ operator, operand_2, operand_3, ... ])`.


### Expression Operators {#sec-expression-operators}

There are several classes of operators as follows:

1. **Numeric**: The `numeric` operand can be an integer, unsigned integer, or floading point value.
1. **Set**: The `set` operand can be an set (array) of any primitive value or a set of arrays containing any primitive value.
The position of the items in a set is unordered, while the position of items in an array within a set
is ordered.
1. **Date-Time**: The date-time operators compare two date-time values,
while the `epoch` operators determine if a date-time value
is within a range defined by an epoch and a grece period relative to the epoch.
1. **Mask**: The `mask` operator compares two bit fields where a bit-field is compared to
a second bit-field using a bit-field-mask that selects the bits to be compared.
The bit-field may contain a sequence of bytes of any length.
The bit-field-mask should be the same length as the bit-field.

#### Equivalence Operator {#sec-equivalance-operator}

By default, *exact* match rules are assumed. Consequently, no operator artifact is needed when
Evidence values are identical to Reference Values.

### Numeric Expressions {#sec-numeric-expressions}

Numeric operators apply to values that are integers, unsigned integers or floating point numbers.
There are four numeric operators:

1.  **greater-than** (gt),
1.  **greater-than-or-equal** (ge),
1.  **less-than** (lt), and
1.  **less-than-or-equal** (le).

The equals operator is not defined because an exact match rule is the default rule when an Evidence value is identical to a Reference Value.

The numeric operator data type definitions are as follows:

~~~ cddl
{::include cddl/numeric-type.cddl}
~~~

A numeric expression is an array containing a numeric operator and a numeric operand.
The operand contains a numeric Reference Value that is matched with a numeric Evidence value.

Evidence and Reference Values MUST be the same numeric type. For example, if a Reference Value numeric type is
`integer`, then the Evidence numeric value must also be `integer`.

This profile defines four macro numeric expressions, one for each numeric operator:

* `tagged-numeric-gt`,
* `tagged-numeric-ge`,
* `tagged-numeric-lt`, and
* `tagged-numeric-le`.

In each case, the numeric operator is used to evaluate a Reference Value operand against an Evidence value operand
that is obtained from Evidence.

If the expression is read using *infix* notation, the first operand is Evidence, followed by the operator,
followed by the Reference Value operand.

Example:

* <`evidence_numeric`> <`le`> <`reference_numeric`>

The numeric expression definitions are as follows:

~~~ cddl
{::include cddl/numeric-expr.cddl}
~~~

### Set Expressions {#sec-set-expressions}

Set operators allow Reference Values, that are expressed as a set, to be compared with Evidence that
is expressed as either a primitive value or a set.

Set expression statements have two forms:

1. A binary relation between a primitive object 'O' and a set 'S', and
1. A binary relation between two sets, an Evidence set 'S1' and a Reference Values set 'S2'.

The first form, relation between an object and a set, has two operators:

* **member** and
* **not-member**.

The Evidence object 'O' is evaluated with the Reference Values set 'S'.

The `op.member` and `op.not-member` operators expect a Reverence Value set as *operand_2* and a primitive Evidence
value as *operand_1*. Evaluation tests whether *operand_1* is a member of the set *operand_2*.

Example:

* <`evidence-value`> <`set-operator`> <`reference-set`>

The set data type definitions are defined as follows:

~~~ cddl
{::include cddl/set-type.cddl}
~~~

A set expression array contins a set operator followed by a set of Reference Values.
The set is defined by `set-type`.

The set expression type definitions are as follows:

~~~ cddl
{::include cddl/set-expr.cddl}
~~~

Examples:

* <`evidence_object`> <`member`> <`reference_set`>

* <`evidence_object`> <`not-member`> <`reference_set`>

The Evidence object MUST NOT be nil.

The Reference Values set may be the empty set.

The second form, a relation between two sets, has three operators:

* **subset**,
* **superset**, and
* **disjoint**.

The fist set, S1 is Evidence and set, S2 is the Reference Values set.

The `subset`, `superset`, and `disjoint` operators test whether an Evidence set value
satisfies a set operation, given a Reverence Value set.

Examples:

* <`evidence_set`> <`subset`> <`reference_set`>

* <`evidence_set`> <`superset`> <`reference_set`>

* <`evidence_set`> <`disjoint`> <`reference_set`>

The Reference Values and Evidence sets may be the empty set.

The set of sets data type definitions are as follows:

~~~ cddl
{::include cddl/set-of-set-type.cddl}
~~~

For `subset`, every member in the Evidence set 'S1', MUST map to a member in the Reference Values set 'S2'.
The Evidence set, 'S1', MAY be a proper subset of 'S2'. For example, if every member in set 'S1' maps to every member
in set 'S2' then matching is successful. A successful result produces the set 'S1'.

For `superset`, every member in the Reference Values set 'S2', MUST map to a member in the Evidence set 'S1'.
A successful result produces the set 'S1'.

For `disjoint`, every member in the Evidence set 'S1' MUST NOT map to any member in the Reference Values
set 'S2'. A successful result produces the empty set.

The set of sets expression definitions are as follows:

~~~ cddl
{::include cddl/set-of-set-expr.cddl}
~~~

### Time Expressions {#sec-time-expressions}

#### Date-Time Expressions {#sec-date-time-expressions}

Date-time can be expressed in both string `tdate` or numeric `time` formats.
There are four operators that are defined for date-time expressions:

1.  **lt** determines if a date-time Evidence value is less than a Reference Values date-time.

1.  **le** determines if a date-time Evidence value is less than or equal to a Reference Values date-time.

1.  **gt** determines if a data-time Evidence value is greater than a Reference Values date-time.

1.  **ge** determines if a data-time Evidence value is greater than or equal to a Reference Values date-time.

The date-time operators are in fact numeric. Expressions involving string date-time values must be converted to numeric format before the numeric comparison
operator can be applied.

The numeric date-time data type definitions are as follows:

~~~ cddl
{::include cddl/time-type.cddl}
~~~

The string date-time data type definitions are as follows:

~~~ cddl
{::include cddl/tdate-type.cddl}
~~~

The date-time expressions for evaluating time consist of a CBOR tagged record containing a time operator followed by a date-time value.

The `gt` expression compares a date-time value contained in Evidence to a Reference Values date-time.
If the Evidence date-time value is greater-than to the Reference Value,
then the Evidence value is accepted.

The `ge` expression compares a date-time value contained in Evidence to a Reference Values date-time.
If the Evidence date-time value is greater-than-or-equal to the Reference Value,
then the Evidence value is accepted.

The `lt` expression compares a date-time value contained in Evidence to a Reference Values date-time.
If the Evidence date-time value is less-than to the Reference Value,
then the Evidence value is accepted.

The `le` expression compares a date-time value contained in Evidence to a Reference Values date-time.
If the Evidence date-time value is less-than-or-equal to the Reference Value,
then the Evidence value is accepted.

In *infix* notation, a date-time value reported as Evidence in *operand_1*.
The Reference Value expression contains a time comparison operator and *operand_2* contains a reference date-time.

Example:

* <`evidence_date_time`> <`gt`> <`reference_date_time`>

The numeric date-time expression definitions are as follows:

~~~ cddl
{::include cddl/time-expr.cddl}
~~~

The string date-time expression definitions are as follows:

~~~ cddl
{::include cddl/tdate-expr.cddl}
~~~

#### Epoch Expressions {#sec-epoch-expressions}

An epoch expression defines a timing window that can be used to determine recentness of a time stampped message.
By default, the Verifier's current time implicitly defines an epoch.
A grace period defines the epoch window differential, in seconds, that a timestamp must fall within to be valid.

Epochs don't have to rely on current time. {{-epoch-markers}} defines several.

The epoch data type definitions are as follows:

~~~ cddl
{::include cddl/epoch-type.cddl}
~~~

An epoch expression array contains an `epoch-operator` followed by a grace period in seconds that is optionally followed
by a `$tagged-epoch-id`. Epoch operators can be: `gt`, `ge`, `lt`, or `le`. The operator defines the position of
the grace window relative to the epoch and `epoch-grace-seconds` defines the size of the window in seconds.
If the default epoch type is not used, `$tagged-epoch-id` defines the alternate epoch scheme.

The `$epoch-timestamp-type` defines the timestamp type for the epoch scheme. By default, the timestamp is `tdate`.

The `tagged-epoch-expression` is an `epoch-expression` preceded by a CBOR tag for an expression array that has
the value `#6.60010`.

The epoch expression definitions are as follows:

~~~ cddl
{::include cddl/epoch-expr.cddl}
~~~

A variety of epoch expressions can be defined that convenently constrain epoch definition.
The `tagged-exp-epoch-gt` expression defines an epoch window that is greater than the current date and time
by the supplied grace period.

In *infix* notation, the timestamp value is within an epoch window that is defined by the current time,
plus the grace period, and where the `epoch-operator` defines the shape of the epoch window.

Example epoch expression:

* <`evidence_timestamp`> <`epoch-operator`> <`grace_period`> <`current_time`>

The Verifier adds `grace_period` to `current_time` to obtain the epoch window then applies the operator to
determine if the `evidence_timestamp` is within the window.

### Mask Expression {#sec-mask-expression}

Reference Values expressed as an array of bits or bytes that uses a mask can indicate to a Verifier which
bits or bytes of Evidence to ignore.

Reference Value and mask arrays MUST be the same length for the mask to be applied correctly.
Normally, Evidence would not supply a mask, while Endorsed Values would.
The `mask-eq` operator indicates that an Evidence value of type `mask-type` is compared with
a Reference Value of type `mask-type`, and that a mask of type `mask-type` is applied to both
values before comparing values. If the operator is `mask-eq`, then a binary equivalence comparison is applied.

The Verifier MUST ensure the lengths of values and mask are equivalent. If the mask is shorter
than the values, the mask is padded with zeros (0) until it is the same length as the largest value.
If the Evidence or Reference Value length is shorter than the mask, the value is padded with
zeros (0) to the length of the mask.

The masked data type definitions are as follows:

~~~ cddl
{::include cddl/mask-type.cddl}
~~~

If the Evidence bit field is a different length from the Reference Value and mask,
the shorter length bit field is padded with zeros to accommodate the larger bit field.

The `tagged-exp-mask-eq` expression defines a tagged expression that applies the mask equivalence  operator to an Evidence value and a Reference Value using the supplied mask.

In *infix* notation, the Evidence value is *operand_1*, followed by the mask operator, followed by a
Reference Value, *operand_2*, followed by the mask, *operand_3*.

Example:

* <`evidence_value`> <`mask-eq`> <`reference_value`> <`mask`>

If each bit in Evidence has a corresponding matching bit in the Reference Value, then the Evidence
value is accepted.

The masked data expression definitions are as follows:

~~~ cddl
{::include cddl/mask-expr.cddl}
~~~

##  Measurement Extensions {#sec-measurement-extensions}

This profile extends the CoMID `measurement-values-map` with additional code point definitions,
that accommodate Intel SGX and similar architectures.
Measurement extensions don't change Verifier behavior. An extension enables the Verifier to validate the profile compliance of the input evidence and reference values, as it defines the acceptable data types in evidence and the expression operator that is explicitly
supplied with the Reference Values, see {{sec-expression-operators}}.

In cases where Evidence does not exactly match Reference Values, the operator definition determines the
expected data types of the operands.
Expected Verifier behavior is defined in {{sec-intel-verifier-profile}}

### The tee-advisory-ids-type Measurement Extension {#sec-tee-advisory-ids-type}

The `tee.advisory-ids` extension allows the Attester to report known security advisories and a
Reference Values Provider (RVP) to assert updated security advisories.

The `$tee-advisory-ids-type` is used to specify a set of security advisories, where each is identified by a string identifier.
Evidence may report a set of advisories the Attester believes are relevant. The set of advisories are constrained
by the `set-of-set-type` structure.

A Reference Values expression record is defined for this extension that applies the disjoint set operation
to determine if there are advisories outstanding. If no advisories are outstanding, then the empty set signifies
successful matching.

The `$tee-advisory-ids-type` is a list of advisories when used as Endorsements or Evidence and a disjoint set
of advisories when used as a Reference Value.

~~~ cddl
{::include cddl/tee-advisory-ids-type.cddl}
~~~

### The tee-attributes-type Measurement Extension {#sec-tee-attributes-type}

The `tee.attributes` extension enables the Attester to report TEE attributes and an RVP to assert a reference
TEE attributes and mask.

The `$tee-attributes-type` is used to specify TEE attributes in 8 or 16 byte words. If Evidence uses an 8 byte
mask, then the Reference Values expression also uses an 8 byte value and mask.

The `$tee-attributes-type` is a singleton value omitting the mask value when used as Endorsement or Evidence
and a tuple containing the reference and mask when used as a Reference Value.

~~~ cddl
{::include cddl/tee-attributes-type.cddl}
~~~

### The tee-cryptokey-type Measurement Extension {#sec-tee-cryptokey-type}

The `tee.cryptokeys` extension identifies cryptographic keys associated with a Target Environment.
If multiple `$crypto-key-type-choice` measurements are supplied, array position disambiguates each entry.
Appraisal compares values indexed by array position.

~~~ cddl
{::include cddl/tee-cryptokey-type.cddl}
~~~

### The tee-date-type Measurement Extension {#sec-tee-date-type}

The `tee.tcbdate` extension enables the Attester or Endorser to report the TEE date attribute
and a RVP to assert a valid TEE matching operation.

The `$tee-date-type` is a date-time string when used for Evidence or Endorsement.
When used for a Reference Value, either a `tagged-tdate-expression` or a `tagged-epoch-expression` describes
the TCB validity.

~~~ cddl
{::include cddl/tee-date-type.cddl}
~~~

`tdate` strings must be converted to numeric `time` before the `tdate-operator`, which is a numeric operator,
can be applied.

### The tee-digest-type Measurement Extension {#sec-tee-digest-type}

The `tee.mrenclave` and `tee.mrsigner` extensions enable the Attester to report digests for the SGX enclave,
a.k.a., Target Environment, and the signer, a.k.a., Attesting Environment, of the enclave digest.

The `$tee-digest-type` is a record that contains the hash algorithm identifier and the digest value when used
as Evidence.
When used as Reference Values, a set of digests can be asserted. The Evidence digest record must be a member
of the Reference Values set.

~~~ cddl
{::include cddl/tee-digest-type.cddl}
~~~

### The tee-epoch-type Measurement Extension {#sec-tee-epoch-type}

The `tee.epoch` extension enables the Attester to report an epoch Evidence measurement,
and a RVP to assert an epoch Reference Value.

As Evidence, the `$tee-epoch-type` is a `tdate` timestamp.

As a Reference Value, the `$tee-epoch-type` is a grace period, in seconds, that is relative to the
Verifier's current date and time, and an epoch operator: `gt`, `ge`, `lt`, or `le`.
The Verifier evaluates whether the timestamp is within the grace period relative to the current date and time.
The current date and time is implicit, and is assumed to be in `tdate` format.

The `$tee-epoch-type` is an `$epoch-timestamp-type` when used as Evidence or Endorsement
and a `$tagged-epoch-expression` when used as a Reference Value.

~~~ cddl
{::include cddl/tee-epoch-type.cddl}
~~~

### The tee-instance-id-type Measurement Extension {#sec-tee-instance-id-type}

The `tee.instance-id` extension enables the Attester to report the (TBD:instance-id-description) Evidence value
and the RVP to assert an exact-match Reference Value.

The `$tee-instance-id-type` is an unsigned integer.

The `$tee-instance-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-instance-id-type.cddl}
~~~

### The tee-isvprodid-type Measurement Extension {#sec-tee-isvprodid-type}

The `tee.isvprodid` extension enables the Attester to report the ISV product identifier Evidence value
and the RVP to assert an exact-match Reference Value.

The `$tee-isvprodid-type` is an unsigned integer.

The `$tee-isvprodid-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-isvprodid-type.cddl}
~~~

### The tee-miscselect-type Measurement Extension {#sec-tee-miscselect-type}

The `tee.miscselect` extension enables the Attester to report the (TBD:miscselect-description) Evidence value
and the RVP to assert a Reference Value and mask.

The `$tee-miscselect-type` is a 4 byte value and mask.

The `$tee-miscselect-type` is a singleton `mask-type` value when used as Endorsement or Evidence
and a `tagged-mask-expression` when used a Reference Value.

~~~ cddl
{::include cddl/tee-miscselect-type.cddl}
~~~

### The tee-model-type Measurement Extension {#sec-tee-model-type}

The `tee.model` extension enables the Attester to report the TEE model string as Evidence
and the RVP to assert an exact-match Reference Value.

The `$tee-model-type` is a string.

The `$tee-model-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-model-type.cddl}
~~~

### The tee-pceid-type Measurement Extension {#sec-tee-pceid-type}

The `tee.pceid` extension enables the Attester to report the (TBD:pceid-description) as Evidence
and the RVP to assert an exact-match Reference Value.

The `$tee-pceid-type` is a string.

The `$tee-pceid-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-pceid-type.cddl}
~~~

### The tee-svn-type Measurement Extension {#sec-tee-svn-type}

The `tee.isvsvn` extension enables the Attester to report the SVN for the independent software vendor supplied
component as Evidence and the RVP to assert a Reference Value that is greater-than-or-equal to the reported SVN.

The `$tee-svn-type` is either an unsigned integer when reported as Evidence, or a tagged numeric expression
that contains an SVN and a numeric greater-than-or-equal operator. The Verifier ensures the Evidence value is
greater-that-or-equal to the Reference Value.

The `$tee-svn-type` is a numeric when used as Endorsement or Evidence and a `tagged-numeric-expression` when
used as a Reference Value.

~~~ cddl
{::include cddl/tee-svn-type.cddl}
~~~

### The tee-tcb-comp-svn-type Measurement Extension {#sec-tee-tcb-comp-svn-type}

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

### The tee-tcb-eval-num-type Measurement Extension {#sec-tee-tcb-eval-num-type}

The `tee.tcb-eval-num` extension enables the Attester to report a (TBD:tcb-eval-num-description)
as Evidence and the RVP to assert a Reference Value expression that compares the (TBD:tcb-eval-num-description) Evidence
to the Reference Value (TBD:tcb-eval-num-description) using the greater-than-or-equal operator.

The `$tee-tcb-eval-num-type` is an unsigned integer when reported as Evidence and a tagged numeric expression when
asserted as Reference Values.

~~~ cddl
{::include cddl/tee-tcb-eval-num-type.cddl}
~~~

### The tee-tcbstatus-type Measurement Extension {#sec-tee-tcbstatus-type}

The `tee.tcb-status` extension enables the Attester to report the status of the TEE trusted computing base (TCB) as
an array of status strings, as Evidence, and the RVP to assert an array of status arrays as Reference Values where
the Evidence array is a subset of the reference status arrays.

The `$tee-tcbstatus-type` is a status array with a set expressions containing the `subset` operator when used as Evidence.
When used as a Reference Value it is an array of status arrays.

~~~ cddl
{::include cddl/tee-tcbstatus-type.cddl}
~~~

### The tee-vendor-type Measurement Extension {#sec-tee-vendor-type}

The `tee.vendor` extension enables the Attester to report the TEE vendor name as Evidence and for the RVP to assert
the TEE vendor name.

The `$tee-vendor-type` is a string containing the vendor name as a string. The vendor string in Evidence must
exactly match the vendor string in Reference Values.

The `$tee-vendor-type` is an exact match measurement.

~~~ cddl
{::include cddl/tee-vendor-type.cddl}
~~~

# Intel Evidence Profile {#sec-intel-evidence-profile}

Evidence may be integrity protected in various ways including: certificates {{-x509}}, SPDM transcript {{-spdm}}, and CBOR web token (CWT) {{-cwt}}.
Evidence contained in a certificate may be encoded using `DiceTcbInfo` and `DiceTcbInfoSeq` {{-dice-attest}}. Evidence contained in an SPDM payload may
be encoded using the SPDM `Measurement Block` {{-spdm}}. Evidence may be formatted as `concise-evidence` {{-tcg-ce}} and
included in an alias certificate or an SPDM Measurement Manifest.

The `DiceTcbInfo` and SPDM Evidence formats can be translated to the CoMID schema. The concise evidence format is native to CoMID {{-corim}}.
This profile documents evidence mapping from `DiceTcbInfo` and SPDM `Measurement Block` to the CoMID schema, as defined by {{-corim}}.

The CoMID schema extensions defined by this profile, see {{sec-measurement-extensions}}, are applied to `concise-evidence` so that
Verifiers that support this profile can consistently apply a common schema across Evidence, Reference Values, and Endorsements.

## Evidence Hierarchy {#sec-evidence-hierarchy}

Evidence hierarchy refers to SGX layering where the SGX Platform Certification Enclave (PCE) collects measurements of the
Quoting Enclave (QE) and the Quoting Enclaves collect measurments of their respective ISV enclaves (ISVE).
A hierarchy of Evidence consisting of one PCE Evidence, one QE Evidence and one ISVE Evidence.

A complex device may have multiple roots of trust, such as {{-dice}}, each contributing an evidence hierarchy that results in
several Evidence "chains", that together, constitute a complete Evidence hierarchy for the Attester device.

The Evidence hierarchy should form a spanning tree that contains all Attester Evidence. All Attesting Environments
within the device produce the spanning tree. CoRIM manifests contain Reference Values for the spanning tree so that
Verifiers do not assume the spanning tree is defined by Evidence.
Note that a failure or comporomise within the Attester device could result in a portion of the spanning tree being omitted.

Example spanning tree:

- A DICE certificate chain with a DiceTcbInfo extension, a DiceTcbInfoSeq extension, and a `ConceptualMessageWrapper` (CMW)
{{-cmw}} extension containing a CBOR-encoded `tagged-concise-evidence`.
- An SPMD alias intermediate certification chain containing a CMW extension, and an SPDM measurement manifest containing
`tagged-concise-evidence`.

## Concise Evidence {#sec-concise-evidence}

Concise evidence is a CDDL representation of an evidence schema that extends CoMID and CoSWID {{-coswid}} schemas.
Nevertheless, evidence describes the actual state of the Attester. `tagged-concise-evidence` is a CBOR tag for a
concise evidence {{-tcg-ce}}. This profile is compatible with `tagged-concise-evicence`.
CoRIM schema extensions defined by this profile are inherited by `tagged-concise-evidence` through `measurement-values-map` extensions.

The concise evidence schema is defined as follows:

~~~ cddl
{::include concise-evidence/concise-evidence.cddl}
~~~

# Intel Verifier Profile {#sec-intel-verifier-profile}

The verifier algorithm in this document describes the actions of a simplified Verifier that may lack performance optimizations. A verifier implementation that appears outwardly identical to the Verifier described here is treated as meeting this profile.

The Intel verifier profile builds on the verifier defined in Section 5 of {{-corim}}. This profile extends the verifier to recognize
the expressions operator extensions defined by this profile. For example, if a reference numeric value of 15, the expressions
operator representation is a CBOR tagged array containing the operator, `gt`, which is CBOR encoded as `1`,
followed by the reference value `15`, which is a `numeric-type`.
The reference value might be: `#6.60010([ 1, 15])`, while the evidence value is simply a `numeric-type`, such as '14'.
The verifier compares `14` to `15`, evaluating whether `14` is greater-than `15`.

## Complex Expressions {#sec-complex-expressions}

Complex expressions assess whether the Target Environment is in a particular actual state before asserting additional claims.
For example, if an SGX enclave has an `svn` value that is less than the prescribed minimum svn, the enclave status may be
considered "OutOfDate" or may have a known security advisory. The CoMID `conditional-endorsement-triples` or
`conditional-endorsement-series-triples` describe complex expressions.

This profile uses these triples with the reference measurement values extensions described in {{sec-measurement-extensions}}.

# Reporting Attestation Results {#sec-intel-reporting-attestation-results}

Attestation verification can be performed by a pipeline consisting of multiple stages where each input manifest demarks a stage. The final stage
prepares Attestation Results according to Relying Party specifications. This profile expects the Relying Party will, in some fashion, negotiate
the expected results format. The Attestation Results format may expect a summary result such as {{-ar4si}} only, or may expect the `accepted-claims`
in its entirety.

The precise Attestation Results format used, if negotiated by Verifier and Relying Party, should reference this profile to acknowledge
that the Relying Party and Verifier both support the schema extensions defined in this document.

# Security Considerations {#sec-security-considerations}

TODO Security

# IANA Considerations {#sec-iana-considerations}

This document uses the IANA CBOR tag registry. See {{-iana-cbor}}

The document requests reservation of the following CBOR tag:

- Requested tag: 60010

- Data item: array

- Semantics: a CBOR encoded array

- Point of contact: ned.smith&intel.com

- Description of semantics: this document

--- back

# Full Intel Profile CDDL

~~~ cddl
{::include cddl/profile-autogen.cddl}
~~~

~~~ cddl
{::include concise-evidence/concise-evidence.cddl}
~~~

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
