import { Injectable } from '@nestjs/common';
import { createWriteStream } from 'fs';

@Injectable()
export class AppService {
  getHello(): string {
    console.log(`ConfigMap: ${process.env.APP}`);
    console.log(`Secret: ${process.env.API_KEY}`);
    return 'Hello World!';
  }

  getExample(): string {
    const file = createWriteStream('rocketseat.txt');
    for(let x = 0; x <= 5000; x++){
      file.write('Estou escrevendo em um arquivo\n')
    }
    file.end();
    return 'Estou rodando no k8s!';
  }
}
