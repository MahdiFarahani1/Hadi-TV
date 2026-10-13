import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/features/live_tv/data/models/live_channel_model.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

void main() {
  group('LiveChannelModel', () {
    test('fromJson should correctly parse full json payload', () {
      final json = {
        'id': 1,
        'title': 'Hadi TV English',
        'live_url1': 'https://stream1.example.com',
        'live_url2': 'https://stream2.example.com',
        'live_url3': 'https://stream3.example.com',
        'live_url4': 'https://stream4.example.com',
        'logoUrl': 'https://example.com/logo.png',
        'currentProgram': 'Program A',
        'upcomingProgram': 'Program B',
      };

      final model = LiveChannelModel.fromJson(json);

      expect(model.id, 1);
      expect(model.channelName, 'Hadi TV English');
      expect(model.liveUrl1, 'https://stream1.example.com');
      expect(model.liveUrl2, 'https://stream2.example.com');
      expect(model.liveUrl3, 'https://stream3.example.com');
      expect(model.liveUrl4, 'https://stream4.example.com');
      expect(model.logoUrl, 'https://example.com/logo.png');
      expect(model.currentProgram, 'Program A');
      expect(model.upcomingProgram, 'Program B');
    });

    test('fromJson should fall back to default values when optional fields are missing', () {
      final json = {
        'id': 2,
        'title': 'Hadi TV Urdu',
      };

      final model = LiveChannelModel.fromJson(json);

      expect(model.id, 2);
      expect(model.channelName, 'Hadi TV Urdu');
      expect(model.liveUrl1, '');
      expect(model.liveUrl2, '');
      expect(model.liveUrl3, '');
      expect(model.liveUrl4, '');
      expect(model.logoUrl, '');
      expect(model.currentProgram, '');
      expect(model.upcomingProgram, '');
    });

    test('streamUrls should return only non-empty stream URLs in order', () {
      const model = LiveChannelModel(
        id: 3,
        channelName: 'Hadi TV Arabic',
        liveUrl1: 'https://stream1.example.com',
        liveUrl2: '',
        liveUrl3: 'https://stream3.example.com',
        liveUrl4: '',
      );

      expect(model.streamUrls, [
        'https://stream1.example.com',
        'https://stream3.example.com',
      ]);
    });

    test('streamUrls should return empty list when all live URLs are empty', () {
      const model = LiveChannelModel(
        id: 4,
        channelName: 'Hadi TV Farsi',
      );

      expect(model.streamUrls, isEmpty);
    });

    test('toEntity should convert LiveChannelModel to LiveChannel domain entity', () {
      const model = LiveChannelModel(
        id: 5,
        channelName: 'Hadi TV Kids',
        liveUrl1: 'https://stream1.example.com',
        liveUrl2: 'https://stream2.example.com',
        logoUrl: 'https://example.com/kids.png',
        currentProgram: 'Cartoon',
        upcomingProgram: 'Stories',
      );

      final entity = model.toEntity();

      expect(entity, isA<LiveChannel>());
      expect(entity.id, 5);
      expect(entity.channelName, 'Hadi TV Kids');
      expect(entity.logoUrl, 'https://example.com/kids.png');
      expect(entity.streamUrls, [
        'https://stream1.example.com',
        'https://stream2.example.com',
      ]);
      expect(entity.currentProgram, 'Cartoon');
      expect(entity.upcomingProgram, 'Stories');
    });
  });
}
