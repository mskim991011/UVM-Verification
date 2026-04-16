# [SystemVerilog/UVM] Integrated Verification Suite for Digital IP 

이 레포지토리는 디지털 회로 설계 및 SoC 개발의 핵심 역량인 **검증(Verification)** 프로세스를 체계적으로 수행한 프로젝트 모음입니다. 기초 논리 회로부터 산업 표준 프로토콜인 AMBA APB에 이르기까지, UVM(Universal Verification Methodology) 프레임워크를 적용하여 하드웨어 설계의 신뢰성을 보증하는 환경을 구축했습니다.

## Project Background & Motivation

현대 반도체 설계 및 시스템 환경에서 검증은 전체 개발 사이클의 핵심입니다. 단순히 기능이 동작하는지를 확인하는 것을 넘어, **"모든 코너 케이스(Corner Case)에서 오류가 없음"**을 체계적으로 증명하는 능력을 배양하기 위해 본 프로젝트를 진행했습니다.

- **검증 생산성 향상:** 재사용 가능한 UVM 클래스 기반 테스트벤치 구조 설계
- **복잡한 시나리오 제어:** Constraint-driven Random 테스트를 통한 예외 상황 커버리지 확보
- **실무 EDA 환경 숙달:** Linux 서버 환경에서 자동화된 디버깅 워크플로우 구축

##  Tech Stack & Environment

| Category | Tools & Languages |
| :--- | :--- |
| **Language** | SystemVerilog (IEEE 1800), Verilog HDL, UVM 1.2 |
| **Simulator** | Synopsys VCS |
| **Debug** | Synopsys Verdi (FSDB/Waveform Analysis) |
| **Environment** | Linux, GNU Make, Bash |

---

##  Verification Portfolio Overview

본 포트폴리오는 기초 로직부터 인터페이스 프로토콜로 점진적으로 확장되는 5개의 검증 프로젝트로 구성되어 있습니다.

### 1. APB_RAM (AMBA APB Protocol Verification)
- **Description:** AMBA APB(Advanced Peripheral Bus) 인터페이스를 탑재한 메모리 제어기 검증
- **Key Achievement:** APB 프로토콜의 Setup/Access Phase 타이밍 준수 여부 확인 및 스코어보드(Scoreboard)를 통한 Address/Data 정합성 100% 검증

### 2. UART (Universal Asynchronous Receiver/Transmitter)
- **Description:** 비동기 직렬 통신 IP의 데이터 송수신 신뢰성 검증
- **Key Achievement:** 다양한 Baud rate 환경에서 데이터 프레임(Start/Stop bit) 분석 및 패리티(Parity) 에러 검출 로직 검증

### 3. RAM (Synchronous Random Access Memory)
- **Description:** 동기식 Single-port RAM의 읽기/쓰기 동작 무결성 검증
- **Key Achievement:** 컴파일 단계의 Macro expansion 이슈 및 인터페이스 스코프 충돌 트러블슈팅을 통한 UVM 환경 안정화

### 4. Adder & Counter (Foundational Logic)
- **Description:** 기초 조합/순차 논리 회로의 UVM 환경 구축
- **Key Achievement:** Driver-Monitor-Scoreboard 간의 TLM Port 통신 구조 설계 및 UVM Topology 기초 확립

---

##  Key Technical Expertise

### 1. UVM Testbench Architecture
모든 프로젝트는 `uvm_env`, `uvm_agent` (Sequencer, Driver, Monitor), `uvm_scoreboard`로 구성된 계층적 구조를 따릅니다. 이를 통해 테스트 케이스의 독립성을 확보하고 검증 자산의 재사용성을 극대화했습니다.

### 2. Automation Workflow
`Makefile`과 `filelist.f`를 활용하여 시뮬레이션 환경을 자동화했습니다.
- `make sim`: 소스 컴파일 및 시뮬레이션 수행
- `make verdi`: 시뮬레이션 결과(FSDB)를 Verdi로 로드하여 파형 분석
- `make clean`: 임시 빌드 파일 및 로그 초기화

### 3. Professional Debugging
Synopsys Verdi를 활용한 Cross-probing 기법으로 소스 코드와 파형을 연동하여 에러 발생 지점을 신속하게 추적하고 해결했습니다.

---

## 📁 Repository Structure


```text
.
├── APB_RAM/
├── UART/
├── RAM/
├── Adder/
└── Counter/
      ├── rtl/           # 설계 소스 코드 (SystemVerilog)
      ├── tb/            # UVM 기반 테스트벤치 소스
      ├── filelist.f     # 시뮬레이션 참조 파일 경로 목록
      └── Makefile       # 컴파일 및 시뮬레이션 자동화 스크립트
