import 'package:haditv/features/live_tv/data/models/live_channel_model.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

class LiveTvFixtures {
  static const liveChannelModel1 = LiveChannelModel(
    id: 1,
    channelName: 'Hadi TV 1',
    liveUrl1: 'https://stream1.example.com/live.m3u8',
    liveUrl2: 'https://stream2.example.com/live.m3u8',
    liveUrl3: '',
    liveUrl4: '',
    logoUrl: 'https://example.com/logo1.png',
    currentProgram: 'Special Majlis',
    upcomingProgram: 'Daily Dua',
  );

  static const liveChannelModel2Offline = LiveChannelModel(
    id: 2,
    channelName: 'Hadi TV 2',
    liveUrl1: '',
    liveUrl2: '',
    liveUrl3: '',
    liveUrl4: '',
    logoUrl: 'https://example.com/logo2.png',
    currentProgram: '',
    upcomingProgram: '',
  );

  static const liveChannel1 = LiveChannel(
    id: 1,
    channelName: 'Hadi TV 1',
    logoUrl: 'https://example.com/logo1.png',
    streamUrls: [
      'https://stream1.example.com/live.m3u8',
      'https://stream2.example.com/live.m3u8',
    ],
    currentProgram: 'Special Majlis',
    upcomingProgram: 'Daily Dua',
  );

  static const liveChannel2Offline = LiveChannel(
    id: 2,
    channelName: 'Hadi TV 2',
    logoUrl: 'https://example.com/logo2.png',
    streamUrls: [],
    currentProgram: '',
    upcomingProgram: '',
  );

  static const liveChannel3WithSingleUrl = LiveChannel(
    id: 3,
    channelName: 'Hadi TV 3',
    logoUrl: 'https://example.com/logo3.png',
    streamUrls: ['https://stream3.example.com/live.m3u8'],
    currentProgram: 'Quran Recitation',
    upcomingProgram: 'Islamic History',
  );

  static Map<String, dynamic> get sampleLiveTvApiResponse => {
        'tv_list': [
          {
            'id': 1,
            'title': 'Hadi TV 1',
            'logoUrl': 'https://example.com/logo1.png',
            'currentProgram': 'Special Majlis',
            'upcomingProgram': 'Daily Dua',
            'live_url1': '',
            'live_url2': '',
            'live_url3': '',
            'live_url4': '',
          },
          {
            'id': 2,
            'title': 'Hadi TV 2',
            'logoUrl': 'https://example.com/logo2.png',
            'currentProgram': '',
            'upcomingProgram': '',
            'live_url1': '',
            'live_url2': '',
            'live_url3': '',
            'live_url4': '',
          },
        ],
        'live': {
          'id': 1,
          'live_url1': 'https://stream1.example.com/live.m3u8',
          'live_url2': 'https://stream2.example.com/live.m3u8',
          'live_url3': null,
          'live_url4': null,
        },
      };
}
