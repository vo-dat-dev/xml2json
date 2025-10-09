import { Controller, Get, Header } from '@nestjs/common';
import xml2js from 'xml2js';

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

  @Get('info/xml')
  getCustomerInfoByXML() {
    const response = {
      name: 'John Doe',
      email: 'johndoe@example.com',
    };

    const builder = new xml2js.Builder();
    const xml = builder.buildObject(response, { rootName: 'response' });

    return xml;
  }
}
