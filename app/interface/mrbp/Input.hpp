#pragma once

#include <array>
#include <cstdint>
#include <glm/glm.hpp>
#include <optional>

namespace mrbp {

enum class TouchType : uint8_t { Down, Move, Up, Cancel };

struct TouchEvent {
  TouchType type;
  std::array<std::optional<glm::vec2>, 2> touches;

  [[nodiscard]] std::optional<glm::vec2> singleTouchPos() const noexcept {
    for (size_t i = 0; i < touches.size(); ++i) {
      if (touches[i].has_value()) {
        return touches[i].value();
      }
    }
    return {};
  }

  [[nodiscard]] uint32_t touchesCount() const noexcept {
    return (touches[0].has_value() ? 1 : 0) + (touches[1].has_value() ? 1 : 0);
  }
};

enum class KeyType : uint8_t { Down, Up };

enum class KeyCode : uint8_t {
  _0 = 0x1D,
  _1 = 0x12,
  _2 = 0x13,
  _3 = 0x14,
  _4 = 0x15,
  _5 = 0x17,
  _6 = 0x16,
  _7 = 0x1A,
  _8 = 0x1C,
  _9 = 0x19,
  A = 0x00,
  B = 0x0B,
  C = 0x08,
  D = 0x02,
  E = 0x0E,
  F = 0x03,
  G = 0x05,
  H = 0x04,
  I = 0x22,
  J = 0x26,
  K = 0x28,
  L = 0x25,
  M = 0x2E,
  N = 0x2D,
  O = 0x1F,
  P = 0x23,
  Q = 0x0C,
  R = 0x0F,
  S = 0x01,
  T = 0x11,
  U = 0x20,
  V = 0x09,
  W = 0x0D,
  X = 0x07,
  Y = 0x10,
  Z = 0x06,
  Apostrophe = 0x27,
  Backslash = 0x2a,
  Comma = 0x2b,
  Equal = 0x18,
  GraveAccent = 0x32,
  LeftBracket = 0x21,
  Minus = 0x1b,
  Period = 0x2f,
  RightBracket = 0x1e,
  Semicolon = 0x29,
  Slash = 0x2c,
  World1 = 0x0a,
  Backspace = 0x33,
  CapsLock = 0x39,
  Delete = 0x75,
  Down = 0x7d,
  End = 0x77,
  Enter = 0x24,
  Escape = 0x35,
  F1 = 0x7a,
  F2 = 0x78,
  F3 = 0x63,
  F4 = 0x76,
  F5 = 0x60,
  F6 = 0x61,
  F7 = 0x62,
  F8 = 0x64,
  F9 = 0x65,
  F10 = 0x6d,
  F11 = 0x67,
  F12 = 0x6f,
  PrintScreen = 0x69,
  F14 = 0x6b,
  F15 = 0x71,
  F16 = 0x6a,
  F17 = 0x40,
  F18 = 0x4f,
  F19 = 0x50,
  F20 = 0x5a,
  Home = 0x73,
  Insert = 0x72,
  Left = 0x7b,
  LeftAlt = 0x3a,
  LeftControl = 0x3b,
  LeftShift = 0x38,
  LeftSuper = 0x37,
  Menu = 0x6e,
  NumLock = 0x47,
  Page_down = 0x79,
  Page_up = 0x74,
  Right = 0x7c,
  RightAlt = 0x3d,
  RightControl = 0x3e,
  RightShift = 0x3c,
  RightSuper = 0x36,
  Space = 0x31,
  Tab = 0x30,
  Up = 0x7e,
  Kp_0 = 0x52,
  Kp_1 = 0x53,
  Kp_2 = 0x54,
  Kp_3 = 0x55,
  Kp_4 = 0x56,
  Kp_5 = 0x57,
  Kp_6 = 0x58,
  Kp_7 = 0x59,
  Kp_8 = 0x5b,
  Kp_9 = 0x5c,
  KpAdd = 0x45,
  KpDecimal = 0x41,
  KpDivide = 0x4b,
  KpEnter = 0x4c,
  KpEqual = 0x51,
  KpMultiply = 0x43,
  KpSubtract = 0x4e,
};

struct KeyEvent {
  KeyType type;
  KeyCode code;
};

}  // namespace  mrbp
