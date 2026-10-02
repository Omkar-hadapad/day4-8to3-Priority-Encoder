# Day 4 — 8-to-3 Priority Encoder

<p align="center">
  <b>8-to-3 Priority Encoder RTL Design & Verification using Verilog HDL and Cadence Genus.</b>
</p>

<p align="center">
  <code>Specification → Architecture → RTL → Testbench → Simulation → Verification → Synthesis → Timing → PPA → Documentation</code>
</p>

---

## 1. Project Information

| Item                | Details                              |
| ------------------- | ------------------------------------ |
| Project             | Day 4                                |
| Design Title        | `8-to-3 Priority Encoder`            |
| Top Module          | `priority_encoder_8to3_top`         |
| Domain              | Digital VLSI / RTL Design            |
| HDL                 | Verilog HDL                          |
| Design Type         | Combinational Logic Circuit          |
| Verification        | Exhaustive Functional Verification   |
| Verification Result | **256/256 PASS**                     |
| Synthesis Tool      | Cadence Genus                        |
| Simulator            | Cadence NC-Sim                       |
| Genus Version       | 21.14-s082_1                         |
| Technology Library  | `tsmc18`                             |
| Operating Condition | `slow (balanced_tree)`               |
| Wireload Mode       | `enclosed`                           |
| Area Mode           | `timing library`                     |
| Sequential Cells    | **0**                                |
| Combinational Cells | **23**                               |
| Total Leaf Cells    | **23**                               |
| Total Cell Area     | **319.334**                          |
| Total Power         | **7.79658 µW**                       |
| Reported Path Delay | **0.897 ns**                         |
| Timing Status       | **UNCONSTRAINED**                    |
| Status              | **Completed**                        |

---

## 2. Project Overview

This project implements an **8-to-3 priority encoder** using synthesizable Verilog RTL and a structural implementation.

A priority encoder converts multiple input conditions into a binary encoded output while resolving the case where multiple inputs are active by assigning priority to the inputs.

The project contains two implementations:

```text
8-to-3 Priority Encoder
        │
        ├── RTL Implementation
        │
        └── Structural Implementation
                │
                ├── UPPER 4-to-2 block
                └── LOWER 4-to-2 block
```

Both implementations were functionally verified using Cadence NC-Sim.

The supplied testbench exhaustively tested all:

\[
2^8 = 256
\]

possible 8-bit input combinations.

The design was then synthesized using Cadence Genus with the `tsmc18` technology library for area, power, timing-path, hierarchy, fanout, and standard-cell analysis.

---

## 3. Objective

* Understand priority encoder operation.
* Understand priority resolution when multiple inputs are active.
* Design an 8-to-3 priority encoder using combinational RTL.
* Develop a structural implementation for comparison.
* Understand hierarchical decomposition of a larger encoder.
* Write synthesizable Verilog RTL.
* Develop an exhaustive functional verification testbench.
* Verify all 256 possible input combinations.
* Compare RTL and structural behavior.
* Generate SHM waveform data using Cadence NC-Sim.
* Synthesize the design using Cadence Genus.
* Analyze hierarchy and standard-cell mapping.
* Analyze area, timing-path delay, power, and fanout.
* Document actual PPA results without inventing values.
* Build a professional Digital VLSI GitHub portfolio project.

---

## 4. Concept

A priority encoder is a combinational circuit that produces a binary code corresponding to the highest-priority active input.

Unlike a normal encoder, a priority encoder must define what happens when multiple inputs are simultaneously active.

### Basic Concept

```text
I[7:0]
  │
  ▼
┌─────────────────────┐
│ 8-to-3 Priority     │
│ Encoder             │
└──────────┬──────────┘
           │
           ├── Y[2:0]
           │
           └── VALID
```

### Priority Behavior

The exact priority order must follow the implemented RTL/testbench specification.

Conceptually:

```text
Multiple active inputs
          │
          ▼
   Priority evaluation
          │
          ▼
Highest-priority active input
          │
          ▼
    Binary encoding
          │
          ▼
       Y[2:0]
```

The `VALID` signal indicates whether a valid active input is detected according to the implemented design.

> The README does not assume an unverified priority polarity. The repository RTL and testbench are the authoritative definition of the implemented priority order and output behavior.

---

## 5. Hardware Architecture

The project contains both RTL and structural implementations.

### High-Level Architecture

```text
                         I[7:0]
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ▼                           ▼
      ┌───────────────┐          ┌────────────────┐
      │ RTL Priority  │          │ Structural     │
      │ Encoder       │          │ Priority       │
      └───────┬───────┘          │ Encoder        │
              │                  └───────┬────────┘
              │                          │
              ▼                    ┌─────┴─────┐
           Y_rtl                  ▼           ▼
           VALID_rtl          UPPER         LOWER
                                4-to-2       4-to-2
                                  │             │
                                  └──────┬──────┘
                                         │
                                         ▼
                                    Y_structural
                                    VALID_structural
```

### Structural Hierarchy

The supplied Genus hierarchy report shows:

```text
priority_encoder_8to3_top
│
├── RTL
│   └── priority_encoder_8to3_rtl
│
└── STRUCTURAL
    ├── LOWER
    │   └── priority_encoder_4to2_6
    │
    └── UPPER
        └── priority_encoder_4to2
```

The hierarchy confirms that the structural implementation is decomposed into upper and lower 4-to-2 priority encoder blocks.

---

## 6. Functional Specification

### Inputs

| Signal | Width | Description |
| ------ | ----: | ----------- |
| `I`    | 8     | Priority encoder input vector |

The input vector is:

```text
I[7:0]
```

### Outputs

| Signal | Width | Description |
| ------ | ----: | ----------- |
| `Y_rtl` | 3 | Encoded output from RTL implementation |
| `VALID_rtl` | 1 | Valid indication from RTL implementation |
| `Y_structural` | 3 | Encoded output from structural implementation |
| `VALID_structural` | 1 | Valid indication from structural implementation |

### Verification Signals

The supplied simulation probe also observes:

```text
expected_Y
expected_VALID
error_count
i
```

These signals provide visibility into expected behavior and verification status.

---

## 7. Priority Encoding Behavior

The essential behavior of the design is:

```text
Input Vector
     │
     ▼
Check active inputs
     │
     ▼
Resolve priority
     │
     ▼
Select highest-priority active input
     │
     ▼
Generate binary encoded output
     │
     └────► VALID indicates active-input detection
```

When multiple input bits are active simultaneously, the encoder does not treat them as independent outputs. The implemented priority logic selects the input defined as having higher priority by the project specification.

### Important RTL Design Point

A priority encoder is different from a simple encoder because **input ordering matters**.

Therefore, verification must include:

* all-zero input
* one-hot inputs
* multiple-active-input cases
* boundary inputs
* combinations where the priority decision changes

This project goes beyond selected cases by exhaustively testing all 256 input combinations.

---

## 8. RTL and Structural Implementations

The project contains two implementation styles.

### RTL Implementation

```text
priority_encoder_8to3_rtl
```

This implementation represents the encoder behavior at the RTL level.

### Structural Implementation

```text
priority_encoder_8to3
│
├── UPPER
│   └── priority_encoder_4to2
│
└── LOWER
    └── priority_encoder_4to2_6
```

The structural design decomposes the 8-input problem into smaller 4-to-2 priority encoder blocks.

### Comparison Objective

The two implementations allow comparison of:

* Functional behavior
* Hierarchical structure
* Cell count
* Area
* Logic depth
* Power
* Timing-path behavior
* Verification complexity

No implementation is declared universally superior based on the supplied data.

---

## 9. Verification Strategy

The project uses **exhaustive directed functional verification**.

For an 8-bit input:

\[
N_{combinations}=2^8=256
\]

Therefore, complete input-space enumeration requires:

\[
\boxed{256\ combinations}
\]

The supplied NC-Sim result confirms:

```text
Total input combinations tested = 256
ALL TESTS PASSED
```

### Verification Flow

```text
Generate input combination
          ↓
Apply to RTL encoder
          ↓
Apply to structural encoder
          ↓
Generate expected result
          ↓
Compare outputs
          ↓
Update error_count
          ↓
PASS / FAIL
```

---

## 10. Functional Verification

The Cadence NC-Sim session created an SHM waveform database:

```text
database -open waves -into waves.shm -default
```

The following signals were probed:

```text
day4_tb.I
day4_tb.VALID_rtl
day4_tb.VALID_structural
day4_tb.Y_rtl
day4_tb.Y_structural
day4_tb.error_count
day4_tb.expected_VALID
day4_tb.expected_Y
day4_tb.i
```

### Verification Result

```text
==========================================
DAY 4 - 8-to-3 PRIORITY ENCODER
==========================================

ALL TESTS PASSED
Total input combinations tested = 256
Simulation complete via $finish(1) at time 256 NS + 0
```

### Final Verification Status

| Metric | Result |
| ------ | ------ |
| Input combinations | **256** |
| Passed | **256** |
| Failed | **0** |
| Functional result | **ALL TESTS PASSED** |
| Simulation completion | **256 ns** |
| Waveform database | `waves.shm` |

Therefore:

\[
\boxed{256/256\ PASS}
\]

This represents exhaustive enumeration of the 8-bit input space used by the testbench.

---

## 11. RTL vs Structural Verification

The testbench observes both implementations:

```text
                 I[7:0]
                   │
          ┌────────┴────────┐
          │                 │
          ▼                 ▼
     RTL Encoder       Structural Encoder
          │                 │
          ▼                 ▼
       Y_rtl           Y_structural
    VALID_rtl        VALID_structural
          │                 │
          └────────┬────────┘
                   ▼
             Expected Result
                   │
                   ▼
              Error Check
```

The supplied simulation completed with:

```text
ALL TESTS PASSED
```

Therefore, the supplied testbench found no functional mismatch during the 256 tested input combinations.

---

## 12. Simulation

### Simulator

```text
Cadence NC-Sim
```

### Waveform Database

```text
waves.shm
```

### Simulation Time

```text
256 ns
```

### Simulation Completion

```text
$finish
```

The simulator reported:

```text
Simulation complete via $finish(1) at time 256 NS + 0
```

### Recommended Repository Evidence

```text
simulation/
├── console_output.txt
└── waves.shm/
```

Recommended screenshots:

```text
images/
├── verification_pass.png
├── priority_encoder_waveform.png
└── synthesis_hierarchy.png
```

Only actual generated screenshots and waveform evidence should be committed.

---

## 13. Synthesis Flow

The design was synthesized using Cadence Genus.

```text
Verilog RTL
     ↓
Elaboration
     ↓
Logic Synthesis
     ↓
Technology Mapping
     ↓
Standard-Cell Netlist
     ↓
Area / Timing / Power Analysis
```

### Genus Configuration

| Parameter | Actual Value |
| --------- | ------------ |
| Tool | Cadence Genus |
| Version | `21.14-s082_1` |
| Top Module | `priority_encoder_8to3_top` |
| Technology Library | `tsmc18` |
| Operating Condition | `slow (balanced_tree)` |
| Wireload Mode | `enclosed` |
| Area Mode | `timing library` |
| Report Date | Sep 29, 2026 |

---

## 14. Synthesis Hierarchy

The supplied hierarchy report shows:

```text
priority_encoder_8to3_top
│
├── RTL
│   └── priority_encoder_8to3_rtl
│
└── STRUCTURAL
    │
    ├── LOWER
    │   └── priority_encoder_4to2_6
    │
    └── UPPER
        └── priority_encoder_4to2
```

### Hierarchy Interpretation

The top-level design contains:

```text
1 × RTL implementation
1 × Structural implementation
```

The structural implementation contains:

```text
1 × LOWER 4-to-2 encoder
1 × UPPER 4-to-2 encoder
```

This hierarchy is directly reflected in the supplied Genus reports.

---

## 15. Area Analysis

The supplied Genus report gives:

| Metric | Result |
| ------ | ------: |
| Leaf instance count | **23** |
| Physical instance count | **0** |
| Sequential instance count | **0** |
| Combinational instance count | **23** |
| Cell area | **319.334** |
| Physical cell area | **0.000** |
| Net area | **0.000** |
| Total area | **319.334** |

The reported area is retained in the Genus library/tool area units.

No unsupported conversion to `µm²` is made.

### Hierarchical Area

| Hierarchy | Cell Count | Area |
| --------- | ---------: | ---: |
| `priority_encoder_8to3_top` | 23 | **319.334** |
| `RTL / priority_encoder_8to3_rtl` | 10 | **139.709** |
| `STRUCTURAL / priority_encoder_8to3` | 13 | **179.626** |
| `LOWER / priority_encoder_4to2_6` | 5 | **56.549** |
| `UPPER / priority_encoder_4to2` | 5 | **56.549** |

### Area Observation

The supplied report shows:

```text
RTL area        = 139.709
Structural area = 179.626
Top area        = 319.334
```

The top module contains both implementations in the reported hierarchy, so the top-level area reflects the combined synthesized hierarchy.

Therefore, these values should **not** be presented as two separately synthesized alternatives unless separate synthesis runs are performed.

---

## 16. Standard-Cell Mapping

The supplied Genus cell report contains the following technology-mapped cells:

| Cell | Instances | Area |
| ---- | --------: | ---: |
| `AOI21XL` | 1 | 13.306 |
| `INVX1` | 1 | 6.653 |
| `INVXL` | 5 | 33.264 |
| `MX2XL` | 2 | 53.222 |
| `NAND2BXL` | 1 | 13.306 |
| `NAND2XL` | 1 | 9.979 |
| `NAND3BXL` | 2 | 33.264 |
| `NOR3XL` | 1 | 13.306 |
| `OAI21XL` | 2 | 26.611 |
| `OAI221XL` | 1 | 23.285 |
| `OR2X1` | 2 | 26.611 |
| `OR2XL` | 1 | 13.306 |
| `OR3XL` | 2 | 33.264 |
| `OR4X1` | 1 | 19.958 |
| **Total** | **23** | **319.334** |

### Cell-Type Summary

| Type | Instances | Area | Area % |
| ---- | --------: | ---: | ------: |
| Inverter | 6 | 39.917 | 12.5% |
| Logic | 17 | 279.418 | 87.5% |
| Physical cells | 0 | 0.000 | 0.0% |
| **Total** | **23** | **319.334** | **100%** |

### Hardware Interpretation

The behavioral/structural RTL is technology-mapped into standard cells rather than remaining as RTL constructs.

The supplied mapping contains:

```text
23 total standard-cell instances
```

with the largest reported cell-area contribution coming from the logic-cell group.

---

## 17. Timing Analysis

The supplied timing report contains an actual combinational data path:

```text
Path 1: UNCONSTRAINED
Startpoint: I[6]
Endpoint:   Y_structural[0]
Data Path: 897 ps
```

Therefore:

\[
T_{path}=897\ ps
\]

\[
\boxed{T_{path}=0.897\ ns}
\]

### Reported Timing Path

```text
I[6]
 │
 ▼
OR2X1
 │
 ▼
OR3XL
 │
 ▼
MX2XL
 │
 ▼
Y_structural[0]
```

### Path Breakdown

| Timing Point | Cell | Arc | Delay | Arrival |
| ------------ | ---- | --- | ----: | ------: |
| `I[6]` | Input | — | 0 ps | 0 ps |
| `STRUCTURAL/UPPER/g52__7098/Y` | `OR2X1` | B→Y | 249 ps | 249 ps |
| `STRUCTURAL/UPPER/g50__5122/Y` | `OR3XL` | A→Y | 384 ps | 634 ps |
| `STRUCTURAL/g66__1881/Y` | `MX2XL` | S0→Y | 263 ps | **897 ps** |
| `Y_structural[0]` | Output | — | 0 ps | **897 ps** |

The path delay is:

\[
249+384+263=897\ ps
\]

Therefore:

\[
\boxed{897\ ps=0.897\ ns}
\]

### Timing Qualification

The report explicitly identifies the path as:

```text
UNCONSTRAINED
```

The timing summary also reports:

```text
No paths
TNS = 0.0
Violating Paths = 0
```

This does **not** establish timing closure.

The valid conclusion is:

> The supplied Genus report shows a 0.897 ns input-to-output data-path delay for the reported unconstrained path from `I[6]` to `Y_structural[0]`.

### Timing Claims Not Made

This project does not claim:

* setup timing closure
* hold timing closure
* positive timing slack
* maximum operating frequency
* clock-period compliance
* timing constraint satisfaction

---

## 18. Fanout Analysis

The supplied Genus summary reports:

| Metric | Result |
| ------ | ------ |
| Maximum fanout | **5** |
| Maximum-fanout signal | `I[2]` |
| Minimum fanout | **1** |
| Average fanout | **2.0** |

### Observation

The highest reported fanout occurs on:

```text
I[2]
```

with:

```text
Fanout = 5
```

Fanout is relevant to physical implementation because larger loads can influence capacitance and delay. However, the supplied report does not establish a timing violation caused by this fanout.

---

## 19. Power Analysis

The supplied Genus power report is for:

```text
Instance: /priority_encoder_8to3_top
Power Unit: W
PDB Frame: /stim#0/frame#0
```

### Total Power

\[
P_{total}=7.79658\times10^{-6}W
\]

Therefore:

\[
\boxed{P_{total}=7.79658\ \mu W}
\]

### Power Breakdown

| Power Component | Power | Percentage |
| --------------- | ----: | ---------: |
| Leakage | 0.0123135 µW | 0.16% |
| Internal | 3.95642 µW | 50.75% |
| Switching | 3.82785 µW | 49.10% |
| **Total** | **7.79658 µW** | **100%** |

### Power by Category

| Category | Total Power |
| -------- | ----------: |
| Logic | **7.79658 µW** |
| Memory | 0 |
| Register | 0 |
| Latch | 0 |
| Clock | 0 |
| Pad | 0 |
| Other listed categories | 0 |

The supplied report shows that all reported power is associated with the logic category.

### Power Observation

Internal and switching power are the dominant components in this reported stimulus frame:

```text
Internal  = 50.75%
Switching = 49.10%
Leakage   = 0.16%
```

The power result is specific to the supplied Genus power-analysis configuration and stimulus frame. It is not presented as a universal workload-independent power value.

---

## 20. PPA Summary

PPA represents:

* **Power**
* **Performance**
* **Area**

### Day-4 Measured Results

| PPA Metric | Actual Result |
| ---------- | ------------: |
| **Area** | **319.334 library area units** |
| **Power** | **7.79658 µW** |
| **Reported path delay** | **0.897 ns** |
| **Leaf cells** | **23** |
| **Sequential cells** | **0** |
| **Combinational cells** | **23** |
| **Maximum fanout** | **5 (`I[2]`)** |
| **Timing status** | **UNCONSTRAINED** |
| **Functional verification** | **256/256 PASS** |

### Baseline PPA Representation

```text
┌─────────────────────────────────────┐
│       DAY 4 — PPA BASELINE          │
├─────────────────────────────────────┤
│ Area       : 319.334                │
│ Power      : 7.79658 µW             │
│ Delay      : 0.897 ns*              │
│ Cells      : 23                     │
│ Fanout     : 5 maximum              │
│ Verification: 256/256 PASS          │
│ Timing     : UNCONSTRAINED          │
└─────────────────────────────────────┘

* Reported delay is from the supplied unconstrained path.
```

---

## 21. Optimization Study

Optimization should be performed from a measured baseline rather than by changing RTL without measurement.

### Current Baseline

```text
Area  = 319.334
Power = 7.79658 µW
Delay = 0.897 ns reported path
Cells = 23
```

### Potential Optimization Areas

The following areas can be investigated in a controlled optimization experiment:

1. Priority logic depth.
2. Structural decomposition.
3. Multiplexer usage.
4. High-fanout signals.
5. Redundant intermediate logic.
6. Boolean simplification.
7. RTL coding style.
8. Technology mapping.
9. Synthesis optimization directives.

### Optimization Method

```text
Baseline RTL
     ↓
Synthesize
     ↓
Record Area / Power / Timing
     ↓
Modify ONE architecture/coding aspect
     ↓
Re-synthesize
     ↓
Verify functionality again
     ↓
Compare PPA
```

### Important Rule

Optimization must **not compromise functional behavior**.

Every optimization iteration should preserve:

```text
256/256 functional verification
```

before its PPA results are accepted.

### Current Optimization Status

No PPA improvement is claimed yet.

The values in this README are the **baseline measured results** from the supplied reports.

---

## 22. RTL-to-Hardware Insight

This project demonstrates an important Digital VLSI concept:

```text
Behavioral Intent
      ↓
Verilog RTL
      ↓
Logic Synthesis
      ↓
Boolean Optimization
      ↓
Technology Mapping
      ↓
Standard Cells
      ↓
Area / Timing / Power
```

For the supplied Day-4 synthesis:

```text
Priority Encoder RTL
        ↓
23 technology-mapped cells
        ↓
319.334 library area units
```

The synthesized hardware is therefore determined by both:

* RTL architecture
* synthesis and technology-mapping decisions

---

## 23. Common Mistakes

### 1. Treating a Priority Encoder as a Normal Encoder

A normal encoder and priority encoder differ when multiple inputs are active.

### 2. Incorrect Priority Order

The priority order must exactly match the implemented specification.

### 3. Ignoring Multiple-Active Inputs

Testing only one-hot cases is insufficient for a priority encoder.

This project addresses this by testing all 256 input combinations.

### 4. Missing Valid Indication

The `VALID` signal must be verified together with the encoded output.

### 5. Verifying Only the RTL

The project also observes the structural implementation:

```text
Y_rtl
Y_structural
VALID_rtl
VALID_structural
```

### 6. Confusing Simulation with Synthesis

Simulation establishes functional behavior under the tested conditions.

Synthesis reports establish implementation metrics such as:

```text
Area
Cell Mapping
Timing Path
Power
Fanout
```

### 7. Misinterpreting `TNS = 0`

The timing summary contains:

```text
No paths
TNS = 0
```

and the detailed path is:

```text
UNCONSTRAINED
```

Therefore this is not equivalent to timing closure.

### 8. Reporting the Top Area as an Alternative Comparison

The top hierarchy contains both RTL and structural implementations. Therefore:

```text
Top area = 319.334
```

should not be used as a standalone comparison against `139.709` or `179.626` as if they came from independent synthesis runs.

---

## 24. Verification Status

| Verification / Analysis Item | Status |
| ---------------------------- | ------ |
| Specification | **Complete** |
| Architecture | **Complete** |
| RTL implementation | **Complete** |
| Structural implementation | **Complete** |
| Testbench | **Complete** |
| Simulation | **Complete** |
| Exhaustive input testing | **Complete** |
| Input combinations tested | **256/256** |
| Functional failures | **0** |
| RTL/Structural observation | **Complete** |
| Waveform database | **Available (`waves.shm`)** |
| Synthesis | **Complete** |
| Hierarchy | **Complete** |
| Standard-cell mapping | **Complete** |
| Area | **Complete** |
| Timing-path analysis | **Complete** |
| Power | **Complete** |
| PPA baseline | **Complete** |
| Timing closure | **Not claimed** |
| Formal verification | **Not performed** |
| UVM | **Not performed** |
| Constrained-random verification | **Not performed** |
| Functional coverage | **Not separately reported** |
| Physical design | **Not performed** |
| Optimization improvement | **Not yet claimed** |

---

## 25. Limitations

### Timing

The detailed timing path is explicitly:

```text
UNCONSTRAINED
```

Therefore:

* no timing closure is claimed
* no setup/hold closure is claimed
* no maximum frequency is claimed
* no positive slack is claimed

### Area

The reported:

```text
319.334
```

is retained as the Genus-reported library/tool area value.

It is not converted to `µm²` because the supplied report does not establish that unit.

### Power

The reported:

```text
7.79658 µW
```

corresponds to:

```text
/stim#0/frame#0
```

and should be interpreted within that analysis configuration.

### Verification

The project demonstrates exhaustive input-space simulation for the supplied 8-bit input vector. It does not constitute formal verification or coverage closure.

---

## 26. Future Work

1. Add explicit timing constraints and repeat timing analysis.
2. Compare RTL and structural implementations in separate synthesis runs.
3. Measure isolated area and power for each implementation.
4. Investigate priority-logic depth.
5. Investigate high-fanout signals.
6. Perform controlled RTL optimization.
7. Re-run all 256 functional tests after each optimization.
8. Add SystemVerilog assertions.
9. Add functional coverage reporting.
10. Explore constrained-random verification.
11. Perform formal equivalence checking.
12. Integrate the encoder into a larger control datapath.
13. Continue into Cadence Innovus physical design.
14. Compare pre-layout and post-layout PPA.

---

## 27. Industry Connection

Priority encoders are fundamental combinational blocks used in:

* interrupt controllers
* arbitration logic
* request/grant systems
* control logic
* instruction and status decoding
* leading-one / leading-zero detection structures
* datapath control
* bus arbitration
* processor and SoC control paths
* digital VLSI and ASIC designs

### Skills Demonstrated

* Digital logic design
* Priority encoding
* Combinational RTL
* Verilog HDL
* Structural RTL
* Hierarchical design
* Exhaustive functional verification
* RTL vs structural comparison
* Cadence NC-Sim
* SHM waveform analysis
* Cadence Genus
* Standard-cell mapping
* Area analysis
* Timing-path analysis
* Power analysis
* Fanout analysis
* PPA documentation
* GitHub project documentation

### Relevant Industry Roles

* RTL Design Engineer
* ASIC Design Engineer
* Design Verification Engineer
* Digital Design Engineer
* FPGA Design Engineer
* VLSI Design Engineer

---

## 28. GATE Relevance

Important concepts demonstrated by this project:

* Encoders
* Priority encoders
* Combinational circuits
* Truth tables
* Boolean logic
* Logic minimization
* Propagation delay
* Fanout
* Hierarchical digital design

### Encoder Width Relation

For an `n`-input encoder, the encoded output generally requires:

\[
\lceil \log_2(n) \rceil
\]

bits for binary representation.

For this project:

\[
\lceil \log_2(8) \rceil = 3
\]

Therefore:

```text
8 inputs → 3-bit encoded output
```

The additional `VALID` signal provides an indication that an active input condition exists according to the implemented design.

---

## 29. Interview Questions

### Basic

**Q1. What is a priority encoder?**

A priority encoder is a combinational circuit that generates a binary code corresponding to the selected active input according to a defined priority order.

**Q2. What is the difference between an encoder and a priority encoder?**

A priority encoder defines deterministic behavior when multiple inputs are active simultaneously.

**Q3. Why is priority important?**

Without priority resolution, multiple active inputs could produce an ambiguous encoded result.

---

### RTL

**Q4. What type of circuit is an 8-to-3 priority encoder?**

It is a combinational logic circuit.

**Q5. What is the output width required to encode eight inputs?**

Three bits:

\[
\log_2(8)=3
\]

**Q6. Why is a `VALID` signal useful?**

It distinguishes the condition where a valid active input exists from the condition where no input is active, according to the implemented design.

---

### Verification

**Q7. How many input combinations exist for an 8-bit input?**

\[
2^8=256
\]

**Q8. How many combinations were tested in this project?**

```text
256
```

**Q9. What was the verification result?**

```text
256/256 PASS
0 FAIL
```

**Q10. Why is exhaustive testing useful for this design?**

Because the complete 8-bit input space contains only 256 combinations, making full input-space simulation practical.

---

### Synthesis

**Q11. How many leaf cells were synthesized?**

```text
23
```

**Q12. How many sequential cells were synthesized?**

```text
0
```

**Q13. What is the reported total cell area?**

```text
319.334
```

**Q14. What standard-cell library was used?**

```text
tsmc18
```

---

### Timing

**Q15. What is the reported path delay?**

```text
897 ps = 0.897 ns
```

**Q16. What is the reported path?**

```text
I[6] → Y_structural[0]
```

**Q17. Is the timing path constrained?**

No. The report explicitly identifies it as:

```text
UNCONSTRAINED
```

**Q18. Can the reported 0.897 ns directly be converted into a validated maximum clock frequency?**

No. The path is unconstrained and is an input-to-output combinational delay rather than a complete constrained clock timing analysis.

---

### Power / PPA

**Q19. What is the total reported power?**

```text
7.79658 µW
```

**Q20. What are the dominant power components?**

```text
Internal  = 50.75%
Switching = 49.10%
```

**Q21. What is the maximum reported fanout?**

```text
5 on I[2]
```

**Q22. What should be checked after an RTL optimization?**

At minimum:

```text
Functional correctness
Area
Timing
Power
Cell count
Fanout
```

---

### Advanced

**Q23. Why might a structural implementation have different PPA from an RTL implementation?**

Different architectural decomposition and logic structure can lead synthesis to produce different Boolean networks and technology mappings.

**Q24. How would you fairly compare the two implementations?**

Synthesize them in separate equivalent runs using the same:

```text
Technology library
Operating condition
Constraints
Wireload configuration
Synthesis settings
Analysis methodology
```

Then compare their measured area, timing, power, and verification results.

**Q25. What is the key optimization rule for this project?**

> Improve implementation metrics without changing the verified functional behavior.

---

## 30. Project Metrics Snapshot

```text
╔══════════════════════════════════════════╗
║        DAY 4 — PROJECT SNAPSHOT          ║
╠══════════════════════════════════════════╣
║ Design        : 8-to-3 Priority Encoder  ║
║ Top Module    : priority_encoder_8to3_top║
║ Technology    : tsmc18                   ║
║ Genus         : 21.14-s082_1             ║
║ Leaf Cells    : 23                       ║
║ Area          : 319.334                  ║
║ Power         : 7.79658 µW               ║
║ Path Delay    : 0.897 ns*                ║
║ Max Fanout    : 5 (I[2])                 ║
║ Verification  : 256/256 PASS             ║
║ Timing        : UNCONSTRAINED             ║
╚══════════════════════════════════════════╝

* Reported delay is from the supplied unconstrained timing path.
```

---

## 31. Repository Structure

```text
day4-8to3-priority-encoder/
│
├── README.md
│
├── rtl/
│   ├── priority_encoder_8to3_rtl.v
│   └── priority_encoder_8to3.v
│
├── tb/
│   └── day4_tb.v
│
├── simulation/
│   ├── console_output.txt
│   └── waves.shm/
│
├── reports/
│   ├── area_report.txt
│   ├── cell_area_report.txt
│   ├── hierarchy_report.txt
│   ├── power_report.txt
│   ├── timing_summary.txt
│   └── timing_path_report.txt
│
├── images/
│   ├── verification_pass.png
│   ├── priority_encoder_waveform.png
│   └── synthesis_hierarchy.png
│
└── docs/
    └── project_report.pdf
```

Use the actual filenames generated by your project flow when committing the repository.

---

## 32. Project Status

```text
Specification              ✓ COMPLETE
Architecture               ✓ COMPLETE
RTL                        ✓ COMPLETE
Structural RTL             ✓ COMPLETE
Testbench                  ✓ COMPLETE
Simulation                 ✓ COMPLETE
Exhaustive Verification    ✓ 256/256 PASS
Waveform Database          ✓ AVAILABLE
Synthesis                  ✓ COMPLETE
Hierarchy                  ✓ COMPLETE
Standard-Cell Mapping      ✓ COMPLETE
Area                       ✓ COMPLETE
Power                      ✓ COMPLETE
Timing Path                ✓ COMPLETE
PPA Baseline               ✓ COMPLETE
Optimization Study         ✓ BASELINE ESTABLISHED
Timing Closure             ⚠ NOT CLAIMED
Physical Design            ○ NOT PERFORMED
Documentation              ✓ COMPLETE
```

---

## 33. Learning Outcome

```text
Priority Encoder Concept
          ↓
Priority Resolution
          ↓
Architecture
          ↓
RTL Implementation
          ↓
Structural Decomposition
          ↓
Testbench
          ↓
Exhaustive Simulation
          ↓
RTL / Structural Verification
          ↓
Cadence Genus Synthesis
          ↓
Hierarchy Analysis
          ↓
Standard-Cell Mapping
          ↓
Area / Timing / Power
          ↓
PPA Baseline
          ↓
Optimization Methodology
          ↓
GitHub Documentation
          ↓
Interview Preparation
```

### Key Engineering Question

> **What hardware does this RTL create?**

### Answer

The supplied Genus synthesis maps the Day-4 priority-encoder hierarchy to **23 combinational standard-cell instances**, with a reported total cell area of **319.334 library area units**. The supplied power analysis reports **7.79658 µW**, while the detailed timing report shows a **0.897 ns unconstrained input-to-output data path**.

---

## 34. Evidence Rule

Only evidence generated from the actual project flow should be committed.

```text
RTL
 ↓
Testbench
 ↓
NC-Sim
 ↓
Waveform
 ↓
Genus
 ↓
Reports
 ↓
README
```

Do not fabricate:

* waveform screenshots
* simulation results
* timing values
* area values
* power values
* timing closure
* optimization improvements
* verification claims

The values in this README are restricted to the supplied Day-4 simulation and Genus reports.

---

## 35. Training Flow

```text
Specification
     ↓
Architecture
     ↓
RTL
     ↓
Testbench
     ↓
Simulation
     ↓
Verification
     ↓
Debug
     ↓
Synthesis
     ↓
Timing
     ↓
PPA
     ↓
Optimization
     ↓
Documentation
     ↓
GitHub
     ↓
Interview
```

---

# Day 4 Complete

**8-to-3 Priority Encoder — RTL → Structural Design → Exhaustive Verification → Genus Synthesis → Timing → Power → PPA → Documentation**

### Final Measured Results

```text
Area         : 319.334 library area units
Power        : 7.79658 µW
Path Delay   : 0.897 ns*
Cells        : 23
Max Fanout   : 5 on I[2]
Verification : 256/256 PASS
Timing       : UNCONSTRAINED
```

\* The reported 0.897 ns value is from the supplied unconstrained timing path and is not presented as timing closure or a validated maximum operating frequency.

---

# Next Project — Day 5

## 4-bit Comparator

The next project introduces magnitude comparison:

```text
A[3:0]
   │
   ▼
┌─────────────────┐
│ 4-bit Comparator │
└───────┬─────────┘
        │
        ├── A > B
        ├── A = B
        └── A < B
```

