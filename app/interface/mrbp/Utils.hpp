#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace mrbp {

std::vector<uint8_t> loadResourceFromBundle(std::string const & path) noexcept;

}  // namespace mrbp
