#import <Foundation/Foundation.h>

#include <fstream>
#include <mrbp/Config.hpp>

#include "../interface/mrbp/Utils.hpp"

namespace mrbp {

std::vector<uint8_t> loadResourceFromBundle(std::string const & path) noexcept {
  NSString * pathInBundle = [[NSBundle mainBundle] pathForResource:@(path.c_str()) ofType:nil];
  if (![[NSFileManager defaultManager] fileExistsAtPath:pathInBundle]) {
    NSLog(@"Error in loading '%s': Resource is not found", path.c_str());
    return {};
  }

  std::ifstream f([pathInBundle UTF8String], std::ios::binary);
  try {
    f.seekg(0, f.end);
    auto sz = static_cast<std::streamsize>(f.tellg());
    f.seekg(0, f.beg);
    if (!f) {
      NSLog(@"Error in loading '%s': Only %ld bytes from %ld could be read",
            path.c_str(),
            f.gcount(),
            sz);
    }

    std::vector<uint8_t> data(sz);
    f.read(reinterpret_cast<std::ios::char_type *>(data.data()), sz);
    f.close();

    return data;
  } catch (std::exception const & e) {
    NSLog(@"Error in loading '%s': Exception raised %s", path.c_str(), e.what());
    f.close();
  }
  return {};
}

}  // namespace mrbp
