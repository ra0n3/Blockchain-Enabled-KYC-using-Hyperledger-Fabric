import { readFileSync } from 'fs';
import { resolve } from 'path';

const basePath = resolve(__dirname, '../../certs');
const readCryptoFile =
  filename => readFileSync(resolve(basePath, filename)).toString();
const config = {
  isCloud: false,
  isUbuntu: false,
  channelName: 'default',
  channelConfig: readFileSync(resolve(__dirname, '../../channel.tx')),
  chaincodeId: 'bckyc',
  chaincodeVersion: 'v2',
  chaincodePath: 'bckyc',
  orderer0: {
    hostname: 'orderer0',
    url: 'grpc://orderer0:7050',
    pem: readCryptoFile('ordererOrg.pem')
  },
  bankOrg: {
    peer: {
      hostname: 'bank-peer',
      url: 'grpc://bank-peer:7051',
      eventHubUrl: 'grpc://bank-peer:7053',
      pem: readCryptoFile('bankOrg.pem')
    },
    ca: {
      hostname: 'bank-ca',
      url: 'https://bank-ca:7054',
      mspId: 'BankOrgMSP'
    },
    admin: {
      key: readCryptoFile('Admin@bank-org-key.pem'),
      cert: readCryptoFile('Admin@bank-org-cert.pem')
    }
  },
  govtOrg: {
    peer: {
      hostname: 'govt-peer',
      url: 'grpc://govt-peer:7051',
      eventHubUrl: 'grpc://govt-peer:7053',
      pem: readCryptoFile('govtOrg.pem')
    },
    ca: {
      hostname: 'govt-ca',
      url: 'https://govt-ca:7054',
      mspId: 'GovtOrgMSP'
    },
    admin: {
      key: readCryptoFile('Admin@govt-org-key.pem'),
      cert: readCryptoFile('Admin@govt-org-cert.pem')
    }
  },
  // shopOrg: {
  //   peer: {
  //     hostname: 'shop-peer',
  //     url: 'grpcs://shop-peer:7051',
  //     eventHubUrl: 'grpcs://shop-peer:7053',
  //     pem: readCryptoFile('shopOrg.pem')
  //   },
  //   ca: {
  //     hostname: 'shop-ca',
  //     url: 'https://shop-ca:7054',
  //     mspId: 'ShopOrgMSP'
  //   },
  //   admin: {
  //     key: readCryptoFile('Admin@shop-org-key.pem'),
  //     cert: readCryptoFile('Admin@shop-org-cert.pem')
  //   }
  // },
  passportOrg: {
    peer: {
      hostname: 'passport-peer',
      url: 'grpc://passport-peer:7051',
      pem: readCryptoFile('passportOrg.pem'),
      eventHubUrl: 'grpc://passport-peer:7053',
    },
    ca: {
      hostname: 'passport-ca',
      url: 'https://passport-ca:7054',
      mspId: 'PassportOrgMSP'
    },
    admin: {
      key: readCryptoFile('Admin@passport-org-key.pem'),
      cert: readCryptoFile('Admin@passport-org-cert.pem')
    }
  }
};

if (process.env.LOCALCONFIG) {
  config.orderer0.url = 'grpcs://localhost:7050';

  config.bankOrg.peer.url = 'grpcs://localhost:7051';
  // config.shopOrg.peer.url = 'grpcs://localhost:8051';
  config.passportOrg.peer.url = 'grpcs://localhost:8051';
  config.govtOrg.peer.url = 'grpcs://localhost:9051';

  config.bankOrg.peer.eventHubUrl = 'grpcs://localhost:7053';
  // config.shopOrg.peer.eventHubUrl = 'grpcs://localhost:8053';
  config.passportOrg.peer.eventHubUrl = 'grpcs://localhost:8053';
  config.govtOrg.peer.eventHubUrl = 'grpcs://localhost:9053';

  config.bankOrg.ca.url = 'https://localhost:7054';
  // config.shopOrg.ca.url = 'https://localhost:8054';
  config.passportOrg.ca.url = 'https://localhost:8054';
  config.govtOrg.ca.url = 'https://localhost:9054';
}

export default config;

// export const DEFAULT_CONTRACT_TYPES = [
//   {
//     Number : '0001',
//     Username: 'Admin',
//     Password: 'AdminPassword',
//     FirstName: 'Admin',
//     LastName: 'Admin',
//   },
//   {
//     Number : '0002',
//     Username: 'Admin1',
//     Password: 'Admin1Password',
//     FirstName: 'Admin1',
//     LastName: 'Admin1',
//   }

// ];
  
  // {
  //   uuid: '1d640cf7-9808-4c78-b7f0-55aaad02e9e5',
  //   shopType: 'B',
  //   formulaPerDay: 'price * 0.02',
  //   maxSumInsured: 3500.00,
  //   theftInsured: false,
  //   description: 'Insure Your Bike',
  //   conditions: 'Simple contract terms.',
  //   minDurationDays: 3,
  //   maxDurationDays: 10,
  //   active: true
  // },
  // {
  //   uuid: '17210a72-f505-42bf-a238-65c8898477e1',
  //   shopType: 'P',
  //   formulaPerDay: 'price * 0.001 + 5.00',
  //   maxSumInsured: 1500.00,
  //   theftInsured: true,
  //   description: 'Phone Insurance Contract',
  //   conditions: 'Exemplary contract terms here.',
  //   minDurationDays: 5,
  //   maxDurationDays: 10,
  //   active: true
  // },
  // {
  //   uuid: '17d773dc-2624-4c22-a478-87544dd0a17f',
  //   shopType: 'P',
  //   formulaPerDay: 'price * 0.005 + 10.00',
  //   maxSumInsured: 2500.00,
  //   theftInsured: true,
  //   description: 'Premium SmartPhone Insurance',
  //   conditions: 'Only for premium phone owners.',
  //   minDurationDays: 10,
  //   maxDurationDays: 20,
  //   active: true
  // },
  // {
  //   uuid: 'd804f730-8c77-4583-9247-ec9e753643db',
  //   shopType: 'S',
  //   formulaPerDay: '25.00',
  //   maxSumInsured: 5000.00,
  //   theftInsured: false,
  //   description: 'Short-Term Ski Insurance',
  //   conditions: 'Simple contract terms here.',
  //   minDurationDays: 3,
  //   maxDurationDays: 25,
  //   active: true
  // },
  // {
  //   uuid: 'dcee27d7-bf3c-4995-a272-8a306a35e51f',
  //   shopType: 'S',
  //   formulaPerDay: 'price * 0.001 + 10.00',
  //   maxSumInsured: 3000.00,
  //   theftInsured: true,
  //   description: 'Insure Ur Ski',
  //   conditions: 'Just do it.',
  //   minDurationDays: 1,
  //   maxDurationDays: 15,
  //   active: true
  // },
  // {
  //   uuid: 'c06f95d6-9b90-4d24-b8cb-f347d1b33ddf',
  //   shopType: 'BPS',
  //   formulaPerDay: '50',
  //   maxSumInsured: 3000.00,
  //   theftInsured: false,
  //   description: 'Universal Insurance Contract',
  //   conditions: 'Universal Contract Terms here. For all types of goods.',
  //   minDurationDays: 1,
  //   maxDurationDays: 10,
  //   active: true
  // }

