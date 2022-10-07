#=============================================================================
# Copyright (c) 2022, NVIDIA CORPORATION.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=============================================================================

function(nvtx3_add_install_rules)
  include(CMakePackageConfigHelpers)
  include(GNUInstallDirs)

  #-------------------------------------------------------
  # Extract the version information from the nvtx3-c target
  get_target_property(NVTX3_VERSION nvtx3-c VERSION)

  string(REPLACE "." ";" version_as_list "${NVTX3_VERSION}")
  list(GET version_as_list 0 NVTX3_VERSION_MAJOR)
  list(GET version_as_list 1 NVTX3_VERSION_MINOR)
  list(GET version_as_list 2 NVTX3_VERSION_PATCH)

  #-------------------------------------------------------
  # build directory export
  # configure_package_config_file("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/nvtx3-config.cmake.in"
  #                               "${PROJECT_BINARY_DIR}/nvtx3-config.cmake"
  #                               INSTALL_DESTINATION "${PROJECT_BINARY_DIR}")
  # write_basic_package_version_file(
  #   "${PROJECT_BINARY_DIR}/nvtx3-config-version.cmake" VERSION ${NVTX3_VERSION}
  #   COMPATIBILITY AnyNewerVersion)

  #-------------------------------------------------------
  # install directory export
  set(install_location "${CMAKE_INSTALL_LIBDIR}/cmake/nvtx3")
  set(scratch_dir "${PROJECT_BINARY_DIR}/cmake/nvtx3_to_install/")

  configure_package_config_file("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/nvtx3-config.cmake.in"
                                "${scratch_dir}/nvtx3-config.cmake"
                                INSTALL_DESTINATION "${install_location}")
  write_basic_package_version_file(
        "${scratch_dir}/nvtx3-config-version.cmake" VERSION ${NVTX3_VERSION}
        COMPATIBILITY AnyNewerVersion)

  # install nvtx3 headers
  install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/nvtx3"
          DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

  # install everything we have generated
  install(DIRECTORY "${scratch_dir}/" DESTINATION "${install_location}")

  install(TARGETS nvtx3-c nvtx3-cpp
          DESTINATION "${CMAKE_INSTALL_LIBDIR}"
          EXPORT nvtx3-targets
          )
  # install the nvtx3 targets to nvtx3-targets.cmake
  install(EXPORT nvtx3-targets
          FILE   nvtx3-targets.cmake
          NAMESPACE nvtx3::
          DESTINATION "${install_location}")
endfunction()
