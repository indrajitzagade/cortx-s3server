/*
 * Copyright (c) 2021 Seagate Technology LLC and/or its Affiliates
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * For any questions about this software or licensing,
 * please email opensource@seagate.com or cortx-questions@seagate.com.
 *
 */

#pragma once

#ifndef __S3_SERVER_S3_OBJECT_VERSIONING_HELPER_H__
#define __S3_SERVER_S3_OBJECT_VERSIONING_HELPER_H__

#include <chrono>
#include <cstdint>
#include <string>

class S3ObjectVersioningHelper {
 public:
  S3ObjectVersioningHelper() = delete;
  S3ObjectVersioningHelper(const S3ObjectVersioningHelper&) = delete;
  S3ObjectVersioningHelper& operator=(const S3ObjectVersioningHelper&) = delete;

  // Generate a Version ID timestamp from a point in time. The timestamp is
  // a value in milliseconds based on the Unix timestamp. The values are
  // sorted in reserve order, i.e. newer points in time generate smaller
  // timestamp values.
  static uint64_t generate_timestamp(
      const std::chrono::system_clock::time_point& tp);

  // Get a Version ID based on the version ID timestamp
  static std::string get_versionid_from_timestamp(uint64_t ts);
};
#endif
