# frozen_string_literal: true

# Licensed to the Software Freedom Conservancy (SFC) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The SFC licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Selenium
  module WebDriver
    class DriverFinder
      def self.path(options, klass)
        path = klass.driver_path
        path = path.call if path.is_a?(Proc)

        path ||= begin
          SeleniumManager.driver_path(options) unless options.is_a?(Remote::Capabilities)
        rescue StandardError => e
          raise Error::NoSuchDriverError, "Unable to obtain #{klass::EXECUTABLE} using Selenium Manager; #{e.message}"
        end

        begin
          Platform.assert_executable(path)
        rescue TypeError
          raise Error::NoSuchDriverError, "Unable to locate or obtain #{klass::EXECUTABLE}"
        rescue Error::WebDriverError => e
          raise Error::NoSuchDriverError, "#{klass::EXECUTABLE} located, but: #{e.message}"
        end

        path
      end
    end
  end
end
