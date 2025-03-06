import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrayerController } from './prayer/prayer/prayer.controller';
import { PrayerService } from './prayer/prayer/prayer.service';

@Module({
  imports: [],
  controllers: [AppController,PrayerController],
  providers: [AppService,PrayerService],
})
export class AppModule {}
