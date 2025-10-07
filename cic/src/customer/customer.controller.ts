import { Controller, Get } from '@nestjs/common';

@Controller('customer')
export class CustomerController {
  @Get('info')
  getCustomerInfo() {
    return {
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
    };
  }
}
