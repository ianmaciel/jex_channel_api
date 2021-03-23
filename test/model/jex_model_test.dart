/*
 * Copyright (c) 2021 Ian Koerich Maciel
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'package:jex_channel_api/model/jex_model.dart';
import 'package:test/test.dart';

import 'fixtures/jex_model.fixture.dart';

void main() {
  group('JExperts model', () {
    test('should add quotes on dummy js-object', () {
      const String jsObject =
          '{name : aName, hobby : [fishing, playing_guitar]}';
      const String expected =
          '{"name" : "aName", "hobby" : ["fishing", "playing_guitar"]}';

      String stringified = JExModel.stringify(jsObject);
      expect(stringified, expected);
    });
    test('should add quotes on jexperts response js-object', () {
      String stringified = JExModel.stringify(JExModelFixture.jsObject);
      expect(stringified, JExModelFixture.expectedJson);
    });
  });
}
