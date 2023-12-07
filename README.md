# Serverless Swagger UI

## Purpose

This is project inspired by [a blog post from Hendrik Hagen](https://www.tecracer.com/blog/2023/03/serverless-swagger-ui-for-aws-api-gateway.html) but intend to use Python instead of Node.js

Check out the original Node.js project on https://github.com/Eraszz/tecracer-blog-projects/tree/main/api-gateway-swagger-ui

## How to run this sample

1. Generate a Flask zip for AWS Lambda layer by executing the [generate-requirements.sh](generate-requirements.sh) script.
2. Export AWS credentials from your favorite AWS account
3. Run `terraform apply`

The deployment will generate an Amazon API Gateway api into the Paris (`eu-west-3`) region, with a demo route `/orders` and the associated documentation at `/api-docs` route.

## Related projects

This project is intended to be a minimal-dependecies standalone example of a Python serverless swagger UI served by Amazon Api Gateway. This project also bundles modified versions of other open-source projects, in particular:

- [Flask Swagger UI](https://github.com/sveint/flask-swagger-ui/tree/master) proposing a blueprint to run Swagger UI in Flask
- [awsgi](https://github.com/slank/awsgi/tree/master) exposing a way to run Flask apps directly in Amazon Api Gateway with AWS Lambda proxy integration

## Mixed content disclaimer

The content inside the `src/api-docs/layer/dist` directory are binaries from the [Swagger UI project](https://github.com/swagger-api/swagger-ui) and duplicated here as example. You may upgrade or downgrade you Swagger UI version according to your need by downloading the appropriate version and copying inside the directory.

## License disclaimer

This project is provided under the [Apache 2.0 license](LICENSE.txt), just like Swagger UI does. This project is freely inspired by [copyrighted work by Hendrik Hagen](https://github.com/Eraszz/tecracer-blog-projects/tree/main/api-gateway-swagger-ui) and other work under the MIT license, like the [Flask Swagger UI license](https://github.com/sveint/flask-swagger-ui/blob/master/LICENSE) or [awsgi license](https://github.com/slank/awsgi/blob/master/LICENSE.txt)

Please ensure all these licenses and copyrights are compatible with your company's policy before using this software.
