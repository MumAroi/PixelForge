# PixelForge Engine — Development Plan v0.2

> **Status:** Ready to Start  
> **Purpose:** เรียนรู้ Rust ผ่านการสร้าง Game Engine ที่นำกลับมาใช้พัฒนาเกมจริงได้  
> **Approach:** Game-first, Engine-second / Incremental Development

## 1. Project Overview

| Item | Specification |
|---|---|
| Engine | PixelForge |
| Language | Rust |
| Graphics / Window / Input | raylib-rs |
| Build | Cargo |
| Initial game types | 2D Pixel Art: Top-down และ Side-scrolling |
| Future game types | Isometric และ HD-2D |
| Multiplayer target | Host–Client, LAN ก่อน Online Co-op 2–4 คน |
| Initial tile size | 32×32 px (ปรับค่าได้ในอนาคต) |
| Platforms | Windows / Linux / macOS |
| Development style | Code-first, Modular Monolith |

### เป้าหมาย

1. เรียนรู้ Rust: Ownership, Borrowing, Struct, Enum, Traits, Generics, Error Handling และ Testing
2. สร้าง Engine Core ที่นำกลับมาใช้ได้ในเกมหลายแนว
3. สร้าง Top-down และ Side-scrolling Demo ที่ใช้ Engine ร่วมกัน
4. เตรียมสถาปัตยกรรมให้ขยายเป็น Multiplayer และ 2.5D ในอนาคต โดยไม่พยายามสร้างทั้งหมดตั้งแต่แรก

### หลักการออกแบบ

- **Game-first, Engine-second:** ทำระบบจากกรณีใช้งานจริงก่อนแยกเป็น Engine Module
- **Testable Core:** Game Logic ควรทดสอบได้โดยไม่เปิดหน้าต่าง
- **Clear Ownership:** กำหนดเจ้าของ Resource และ State ให้ชัดเจน
- **No premature abstraction:** ยังไม่ทำ ECS, Plugin System หรือ Editor ตั้งแต่ต้น
- **Rendering independence:** ลดการผูก Game Logic กับ raylib เพื่อรองรับ Headless Host/Server ในอนาคต
- **Version pinning:** ตรึงเวอร์ชัน Rust Toolchain และ Dependencies หลังตรวจสอบความเข้ากันได้

## 2. Target Architecture

```text
Game Layer
  ├── Top-down Demo
  ├── Side-scrolling Demo
  └── Future Games
         │
         ▼
PixelForge Engine
  ├── Core / Time / Game Loop
  ├── Input
  ├── Math / Transform
  ├── Entity / Scene
  ├── Assets / Animation
  ├── Tilemap / Collision / Physics2D
  ├── Audio / Diagnostics
  └── Renderer2D / Camera2D
         │
         ▼
raylib-rs (Window / Graphics / Input / Audio)
         │
         ▼
Windows / Linux / macOS

Future:
  ├── Network Layer + Shared Simulation
  ├── Isometric Projection
  └── HD-2D / 3D Rendering Research
```

เริ่มจาก Cargo Package เดียวก่อน แล้วแยก Workspace หรือ Crates เมื่อมีขอบเขต Module ชัดเจน

### Module Responsibilities

| Module | หน้าที่ | เริ่มใน |
|---|---|---|
| Core | Application Lifecycle, Game Loop, Time | M1 |
| Input | Keyboard / Mouse, Press / Hold | M1 |
| Math | Vector / Rectangle / Transform | M1–M2 |
| Renderer2D | Primitive, Sprite, Draw Commands | M1–M2 |
| Camera2D | View, Zoom, Coordinate Conversion | M2 |
| Assets | Load / Cache / Unload Resources | M2–M3 |
| Entity | Entity ID และ Lifecycle | M3 |
| Scene | Scene Loading / Switching | M3 |
| Tilemap | Tile Layers / Map Data | M3 |
| Collision | AABB / Overlap / Resolution | M3 |
| Animation | Sprite Sheet / Frame Timing | M2–M3 |
| Physics2D | Velocity / Gravity / Platform Movement | M4 |
| Diagnostics | FPS / Debug Overlay / Logging | M1–M5 |
| Network | Host–Client / Replication | M6 |
| Renderer3D | HD-2D Experiments | M7 |

## 3. Rendering and Simulation Rules

### 2D Pixel Art

- รองรับ Top-down และ Side-scrolling ผ่าน Renderer2D เดียวกัน
- ใช้ Nearest-neighbor Filtering สำหรับ Pixel Art
- แยก Logical Resolution กับ Window Resolution
- รองรับ Integer Scaling และ Letterboxing
- เริ่มต้นทดลอง Logical Resolution 320×180 (เปลี่ยนได้ตามเกม)
- รองรับ Configurable Tile Size โดยเริ่มที่ 32×32
- Top-down: Y-Sorting เฉพาะวัตถุที่ต้องใช้
- Side-scrolling: Layer / Z-Order, Gravity และ Jumping ใน Gameplay/Physics Layer

### Timing

- เป้าหมาย Simulation: Fixed Update 60 Hz
- Rendering ไม่ผูกกับ Simulation Rate
- จำกัดจำนวน Fixed Updates ต่อ Frame เพื่อป้องกัน Spiral of Death
- เริ่ม M1 ด้วย Loop แบบง่าย แล้วเพิ่ม Fixed Timestep เมื่อเข้าใจพื้นฐาน
- Frame Interpolation เพิ่มเมื่อจำเป็น

### Multiplayer Readiness

- Game State ไม่ขึ้นกับ Texture หรือ Window
- Entity ID มีตัวตนที่เสถียร ไม่อิง Index ของ Array โดยตรงเมื่อเข้าสู่ระบบ Entity จริง
- Host เป็นผู้ดูแล Shared World State ในรูปแบบ Host-authoritative ที่เราจะออกแบบ
- ยังไม่พัฒนา Network จริงจนกว่า Offline Simulation ใช้งานได้

## 4. Development Roadmap

> ระยะเวลาเป็นการประมาณสำหรับการเรียนรู้ควบคู่พัฒนา ไม่ใช่ Deadline

| Milestone | Deliverable | Estimate | Priority |
|---|---|---|---|
| M1 — Foundation | Cargo, Window, Game Loop, Input, Time, Basic Rendering | 1–2 สัปดาห์ | P0 |
| M2 — Pixel Rendering | Sprite, Animation, Camera2D, Pixel-perfect Scaling | 2–3 สัปดาห์ | P0 |
| M3 — World System | Entity, Scene, Tilemap, Collision, Assets | 3–5 สัปดาห์ | P0 |
| M4 — Two Playable Demos | Top-down และ Side-scrolling ที่ใช้ Engine ร่วมกัน | 2–4 สัปดาห์ | P0 |
| M5 — Developer Tools | Debug Overlay, Save/Load, Serialization, Testing | 2–4 สัปดาห์ | P1 |
| M6 — Multiplayer | Host–Client, LAN, Replication, Online Co-op 2–4 Players | 4–8+ สัปดาห์ | P2 |
| M7 — 2.5D Research | Isometric, HD-2D, Lighting, Shaders | ยังไม่กำหนด | P2 |

### M2 — Pixel Rendering

- [ ] Texture และ Sprite Rendering
- [ ] Sprite Sheet Animation
- [ ] Camera2D
- [ ] Logical Resolution + Integer Scaling
- [ ] Nearest-neighbor Filtering
- [ ] Rendering Layers และ Y-Sorting เบื้องต้น

### M3 — World System

- [ ] Entity ID และ Lifecycle
- [ ] Scene Management
- [ ] Tilemap 32×32
- [ ] AABB Collision
- [ ] Asset Loading / Caching
- [ ] World / Scene Data Loading

### M4 — Two Playable Demos

- [ ] Top-down Movement / Interaction
- [ ] Side-scrolling Movement / Jump / Gravity
- [ ] ใช้ Rendering, Input, Scene และ Collision Module ร่วมกัน
- [ ] ทดสอบว่า Engine ไม่ผูกกับเกมใดเกมหนึ่ง

### M5 — Developer Tools

- [ ] Debug Overlay
- [ ] Save / Load
- [ ] Scene Serialization
- [ ] Tests และ Diagnostics

### M6 — Multiplayer

- [ ] Offline Simulation ที่ไม่ขึ้นกับ Rendering
- [ ] Local Host–Client สอง Process บนเครื่องเดียว
- [ ] LAN Multiplayer สองเครื่อง
- [ ] Host-authoritative State Replication
- [ ] Player Join / Leave / Disconnect Handling
- [ ] Online Co-op 2–4 คน
- [ ] ตรวจสอบ Latency / Packet Loss / Reconnection

### M7 — 2.5D Research

- [ ] Isometric Coordinate Projection Prototype
- [ ] Depth Sorting Prototype
- [ ] HD-2D / 3D World Prototype
- [ ] Camera / Lighting / Shader Experiments
- [ ] ประเมินความจำเป็นในการ Refactor ก่อนผสานเข้ากับ Engine

## 5. Milestone 1 — Foundation (เริ่มทำก่อน)

**Goal:** โปรแกรมที่เปิดหน้าต่าง แสดงสี่เหลี่ยมแทนตัวละคร เคลื่อนที่ด้วย WASD ได้ และมี Game Loop ที่เข้าใจได้ชัดเจน

| Task | สิ่งที่จะทำ | Rust Concepts | Status |
|---|---|---|---|
| M1.1 Environment Setup | ตรวจสอบ Rust, Cargo และ Toolchain | Toolchain / Cargo | [ ] |
| M1.2 Create Project | สร้างโปรเจกต์และตั้งค่า raylib-rs | Crates / Modules | [ ] |
| M1.3 First Window | เปิด / ปิด Window | Variables / Functions / Ownership | [ ] |
| M1.4 Game Loop | Main Loop / Update / Render | Loop / Scope / Control Flow | [ ] |
| M1.5 Time System | Delta Time / FPS | `f32`, `f64`, Struct / Methods | [ ] |
| M1.6 Input & Movement | WASD / Arrow Keys และ Primitive Player | Enum / Match / `&mut self` | [ ] |
| M1.7 Refactor & Test | แยก Module และเขียน Unit Tests | Result / Visibility / Tests | [ ] |

### M1 Acceptance Criteria

- [ ] เปิดและปิดหน้าต่างเกมได้โดยไม่มี Error
- [ ] เริ่มต้น Window ที่ 1280×720
- [ ] แสดงสี่เหลี่ยมแทนตัวละครได้
- [ ] เคลื่อนที่ด้วย WASD หรือ Arrow Keys ได้
- [ ] ความเร็วการเคลื่อนที่ไม่ขึ้นกับ FPS อย่างผิดปกติ
- [ ] แสดง FPS และ Delta Time ได้
- [ ] แยก Game Logic กับ Rendering ขั้นพื้นฐาน
- [ ] `cargo fmt` ผ่าน
- [ ] `cargo clippy` ผ่านโดยไม่มี Warning ที่ยังไม่จัดการ
- [ ] Unit Tests ที่เกี่ยวข้องผ่าน

**Out of scope M1:** Sprite จริง, Tilemap, Collision, Scene Manager, ECS, Multiplayer

## 6. Non-Goals สำหรับ MVP

- Full ECS
- Visual Level Editor
- Multiplayer ใน Phase แรก
- 3D Physics
- Scripting Language
- Plugin System
- Mobile / Console Deployment
- Full HD-2D Renderer

## 7. Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Rust Ownership / Borrowing ซับซ้อน | Entity / Scene Design ยาก | ใช้ Ownership ที่เรียบง่ายก่อน หลีกเลี่ยง `Rc<RefCell<T>>` โดยไม่จำเป็น |
| raylib-rs / Rust Version Compatibility | Build ล้มเหลว | ตรวจสอบและ Pin Versions ก่อนเริ่ม |
| Pixel Art เบลอหรือสั่น | คุณภาพภาพไม่ตรงเป้าหมาย | Nearest Filtering, Integer Scaling, Camera Tests |
| Multiplayer เพิ่มความซับซ้อน | Scope บานปลาย | ทำ Offline Core ก่อน แล้วเริ่ม Local Host–Client |
| 2.5D ต้อง Refactor | ใช้เวลาพัฒนามาก | แยก Game State กับ Renderer และทำ Prototype พิสูจน์แนวทาง |
| Engine ไม่เสร็จเพราะ Overengineering | ไม่มี Demo ใช้งานจริง | Milestone เล็ก + Acceptance Criteria ชัดเจน |

## 8. Definition of Done

Milestone จะถือว่าเสร็จเมื่อ:

1. มี Demo ที่รันได้จริงตามขอบเขต
2. เข้าใจ Rust Concepts ที่เกี่ยวข้อง และอธิบายเหตุผลการออกแบบได้
3. ผ่าน Tests / Formatting / Lint ที่เกี่ยวข้อง
4. ไม่เพิ่ม Feature นอก Scope โดยไม่จำเป็น
5. สรุปสิ่งที่เรียนรู้และข้อจำกัดก่อนขึ้น Milestone ถัดไป

## 9. Next Step — M1.1 Environment Setup

ยังไม่ต้องเขียน Engine Code ให้ตรวจสอบเครื่องมือก่อน:

```bash
rustc --version
cargo --version
```

จากนั้นตรวจสอบระบบปฏิบัติการและความเข้ากันได้ของ raylib-rs แล้วจึงเริ่ม M1.2 Create Project

---

**หมายเหตุ:** แผนนี้เป็น Living Document สามารถปรับตามผลการทดลองจริง โดยรักษาเป้าหมายหลักคือเรียน Rust และสร้าง Engine ที่ใช้งานได้ทีละขั้น
