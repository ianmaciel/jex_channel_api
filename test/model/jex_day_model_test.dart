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

import 'package:test/test.dart';

import 'package:jex_channel_api/model/jex_day_model.dart';

void main() {
  group('JExperts day model', () {
    test('should parse 00:00 format (HH:mm)', () {
      expect(JExDayModel.parseHHMM('00:00'), Duration(hours: 0, minutes: 0));
      expect(JExDayModel.parseHHMM('01:00'), Duration(hours: 1, minutes: 0));
      expect(JExDayModel.parseHHMM('01:30'), Duration(hours: 1, minutes: 30));
      expect(JExDayModel.parseHHMM('60:59'), Duration(hours: 60, minutes: 59));
      expect(JExDayModel.parseHHMM('99:59'), Duration(hours: 99, minutes: 59));
      expect(JExDayModel.parseHHMM('00:60'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM('100:00'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM('0:00'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM('0:100'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM('0:0'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM('0:'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM(':0'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM(':'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM('6021'), Duration(hours: 0));
      expect(JExDayModel.parseHHMM('00'), Duration(hours: 0));
    });
  });
}
