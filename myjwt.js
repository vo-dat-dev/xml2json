// "use strict";
// // This is an example plugin that add a header to the response

// class KongPlugin {
//   constructor(config) {
//     this.config = config;
//   }

//   async access(kong) {
//     await Promise.all([
//       kong.response.setHeader("x-hello-from-javascript", "Javascript"),
//       kong.response.setHeader("x-javascript-pid", process.pid),
//     ]);
//   }
// }

// module.exports = {
//   Plugin: KongPlugin,
//   Schema: [{ message: { type: "string" } }],
//   Version: "0.1.0",
//   Priority: 0,
// };

"use strict";
const xml2js = require("xml2js");

// This is an example plugin that adds a header to the response
class KongPlugin {
  constructor(config) {
    this.config = config;
  }

  // Giai đoạn xử lý request đầu tiên (access phase)
  async access(kong) {
    kong.request.enable_buffering();

    await Promise.all([
      kong.response.setHeader("x-javascript-pid", process.pid),
    ]);
  }

  // Giai đoạn thay đổi nội dung body của response
  async response(kong) {
    const body = await kong.response.getRawBody();
    kong.response.setHeader("Content-Type", "application/xml");
    xml2js.parseString(body, (err, result) => {
      if (err) {
        console.error("Error parsing XML:", err);
      } else {
        console.log("Converted JSON:", JSON.stringify(result, null, 2));
        kong.response.setHeader(
          "Content-Length",
          JSON.stringify(result, null, 2).length
        );
        kong.response.setRawBody(JSON.stringify(result, null, 2));
      }
    });
    // kong.response.setRawBody("<h1>hello world</h1>");
  }
  // Giai đoạn trước khi request được xử lý, thường dùng để làm các kiểm tra ban đầu
  async preread(kong) {
    // Kiểm tra hoặc chuẩn bị dữ liệu ban đầu ở đây
    kong.log.info("Pre-read phase: preparing for request processing.");
  }

  // Giai đoạn thay đổi URL request hoặc header trong request trước khi gửi đến upstream
  async rewrite(kong) {
    // Thay đổi URL request hoặc các header tại đây
    kong.request.setHeader("x-rewritten-header", "new value");
    kong.log.info("Rewritten request headers.");
  }
}

module.exports = {
  Plugin: KongPlugin,
  Schema: [{ message: { type: "string" } }],
  Version: "0.1.0",
  Priority: 0,
};
