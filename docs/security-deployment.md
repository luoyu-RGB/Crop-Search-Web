# Security deployment

- Set `CROP_DB_URL`, `CROP_DB_USER`, `CROP_DB_PASSWORD`, and `DEEPSEEK_API_KEY` through the server environment. Keep secrets out of the repository.
- Set `CROP_UPLOAD_DIR` to a dedicated directory outside the web root in production. The Tomcat process needs read and write access.
- Image uploads accept real JPEG, PNG, and GIF files only. The maximum dimensions are 6000x6000 pixels and the Servlet limit is 5 MB.
- When deploying over HTTPS, change `WEB-INF/web.xml` from `<secure>false</secure>` to `<secure>true</secure>` and set `CROP_FORCE_HTTPS=true` to enable HSTS.
- AI requests are limited per account and IP in a ten minute window. The DeepSeek client has a 30 second timeout and one automatic retry.
