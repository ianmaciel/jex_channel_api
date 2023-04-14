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

import 'package:jex_channel_api/api/response_parser.dart';
import 'package:jex_channel_api/model/jex_model.dart';
import 'fixtures/response_parser.fixture.dart';

void main() {
  late ResponseParser responseParser;
  setUpAll(() =>
      responseParser = ResponseParser(ResponseParserFixture.responseBody));
  group('Parse JExperts response', () {
    test('should break the response in lines', () {
      List<String> lines = responseParser.getLines();
      expect(lines[0], ResponseParserFixture.lineResponseBody[0]);
      expect(
          lines[lines.length - 1],
          ResponseParserFixture.lineResponseBody[
              ResponseParserFixture.lineResponseBody.length - 1]);
    });
    test('should find the handleCallbackLine', () {
      String handleCallbackLine = responseParser
          .getHandleCallbackLine(ResponseParserFixture.lineResponseBody);
      expect(handleCallbackLine, ResponseParserFixture.lineResponseBody[5]);
    });
    test('should extract the body content', () {
      String bodyContent = responseParser
          .extractBodyContent(ResponseParserFixture.lineResponseBody[5]);
      expect(bodyContent, ResponseParserFixture.bodyContent);
    });
    test('should split the handleCallback line in parameters', () {
      List<String> parameters = responseParser
          .getHandleCallbackParameters(ResponseParserFixture.bodyContent);
      expect(parameters[0], '"16"');
      expect(parameters[1], '"0"');
      expect(parameters[2], ResponseParserFixture.jsObject);
    });
    test('should decode an ISO-8859-1 properly', () {
      String isoString = '"nomeDiaSemana":"S\u00E1b"';
      String decoded = responseParser.decodeIso8859_1(isoString);
      expect(decoded, '"nomeDiaSemana":"Sáb"');
    });
    test('should convert the json body in a map structure', () {
      JExModel jexModel =
          responseParser.parseJsonBody(ResponseParserFixture.jsObject);
      expect(jexModel.formatedEnd, DateTime(2021, 03, 07));
      expect(jexModel.formatedStart, DateTime(2021, 02, 28));
    });
    test('should parse the entire response body', () {
      ResponseParser responseParser =
          ResponseParser(ResponseParserFixture.responseBody);
      JExModel jexModel = responseParser.parseJExModel();
      expect(jexModel.formatedEnd, DateTime(2021, 03, 07));
      expect(jexModel.formatedStart, DateTime(2021, 02, 28));
    });
    test('should remove extra quotes', () {
      expect(ResponseParser.removeExtraQuotes('"test"'), 'test');
      expect(ResponseParser.removeExtraQuotes('test'), 'test');
      expect(ResponseParser.removeExtraQuotes('"test "2""'), 'test "2"');
      expect(ResponseParser.removeExtraQuotes('test "2"'), 'test "2"');
      // ignore: prefer_single_quotes
      expect(ResponseParser.removeExtraQuotes("\"test \"12324\" dhdiushfds \""),
          'test "12324" dhdiushfds ');
      // ignore: prefer_single_quotes
      expect(ResponseParser.removeExtraQuotes("test \"12324\" dhdiushfds "),
          'test "12324" dhdiushfds ');
    });
  });
}
