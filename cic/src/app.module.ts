import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { CustomerController } from './customer/customer.controller';

@Module({
  imports: [],
  controllers: [AppController, CustomerController],
  providers: [AppService],
})
export class AppModule {}
