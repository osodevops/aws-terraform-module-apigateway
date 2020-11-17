Table of Contents
=================

  * [Apigateway](#apigateway)
    * [Message flow](#message-flow)
         * [Defining a REST API](#defining-a-rest-api)
            * [First level - REST API properties](#first-level---rest-api-properties)
            * [Second level - Authorization](#second-level---authorization)
            * [Third level - Back-end integration](#third-level---back-end-integration)
            * [4th level - Deployments](#4th-level---deployments)
    * [Description](#description)
    * [List of resources](#list-of-resources)
       * [outputs](#outputs)
       * [links](#links)
       * [Cloudformation templates for reference](#cloudformation-templates-for-reference)

## Todo
    *TFcode*
    1. targetgroup, user/IAM, SecurityGroupIngress0, custom domain, VPC link with LB connection
    2. multiple methods methodresponse/integrationresponse

    *Build and test*

    *Open api Swagger*

    *Tests*

    *API keys/usage plans*
    1. the monitoring app handles the authentication

### List of uncertainties:
    use of custom domains, includes configuring Route53 records to point to cloudfront distributions
    how to integrate Swagger/openapi specifications with terraform code creation                                
    how flexible does the solution have to be in terms of adding new REST API's later on
### Tests:

    TEST                                                                 TOOL

    1. integration between API Gateway and getProfile app                curl,postman,pytest
    2. integration between API Gateway and Detected app                  curl,postman,pytest
    3. integration between API Gateway and Monitoring app                pytest
    4. infrastucture build test with terraform code                      terraform
    5. infrastucture modify/delete test with terraform code              terraform
    6. create, modify, delete individual REST API endpoints              pytest
    7. create, modify, delete API keys and usage plans for users         pytest
    8. authentication access allowed                                     pytest
    9. authentication access denied                                      pytest
    10. monitoring events                                                pytest
    In addition we could do load, security and extra functional tests with     
    pytest - it is up to the client how much they want us to test
### links

Terraform code to build API Gateway, VPC link, network load balancer (private) 
and custom domainname (Route53 records) with cloudfront link:
https://github.com/clouddrove/terraform-aws-api-gateway
Also check the nginx documentation: 
https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-1/
## Apigateway

This repository contains the Terraform code for the Api Gateway, VPC link, Custom
Domain, network load balancer.

## Message flow
    End user
        |
    Cloudfront <- Custom domain                _DNS_ENDPOINT_ *https://test.detected.app* 
        |
    Api Gateway <-> AWS IAM                    _API_GATEWAY_ *https://2795dll430.execute-api.eu-west-2.amazonaws.com/dev*
        |
    VPC link -> Cluster internal Network LB    _NLB_ ace3bfcc9f7c740b1a234f59728a81c4-8762724ac7823621.elb.eu-west-2.amazonaws.com
                          |
                         EKS
                          |
                         POD
    
### Defining a REST API
#### First level - REST API properties
1. HTTP: GET/POST/DELETE
2. FULLPATH: PATH,PATHPART
3. METHOD REQUEST/RESPONSE
4. PARAMETERS: path,headers,bodymodel,query
#### Second level - Authorization
5. AUTHORIZATION (IAM/LAMBDA)
#### Third level - Back-end integration
6. MAPPING TEMPLATE
7. CONTENT HANDLING (e.g. Passthrough)
8. INTEGRATION REQUEST/RESPONSE
#### 4th level - Deployments
9. STAGES AND DEPLOYMENTS (includes environments)

REST_API.drawio
### Description

Because we are using Virtual Hosts in Nginx based on the incoming url we will 
have to make the API available on that URL. We also need to configure the 
certificate. With Edge optimized cloudfront certificate is automatically included
Then we also need to create records in route53 which point to the cloudfront 
distribution. Api Gateway poins to a load balancer having internal domain name.
Create Custom Domainname in the API Gateway Console.

    Custom Domain
    
    Apigateway
    
    VPCLink
    
    LoadBalancer


    RestAPI0, Type:RestApi

        Resourceapi0, Type:Resource => Methodapi0, Type::Method
    
          Resourceapibook0, Type:Resource => Methodapibook0, Type:Method 
    
            Resourceapibookproxy0:, Type:Resource => Methodapibookproxy0, Type:Method
    
          Resourceapiauthor0, Type: ApiGateway::Resource => Methodapiauthor0, Type:Method
    
            Resourceapiauthorproxy0:, Type:Resource => Methodapiauthorproxy0, Type:Method



## List of resources

    Apigateway (service with name reference api-95d8427d)

    Route53 records

    VPCLink vawurb  AWS:VpcLink

    Deployment0	7ahgto	AWS:Deployment

    Listener elasticloadbalancing  AWS::ElasticLoadBalancingV2::Listener
    
    LoadBalancer	arn:aws:elasticloadbalancing
    
    Resourceapi0	1a8od8	AWS:Resource
    
    Resourceapiauthor0	8dqylq	AWS:Resource
    
    Resourceapiauthorproxy0	rzp65v	AWS:Resource
    
    Resourceapibook0	yg6a1l	AWS:Resource
    
    Resourceapibookproxy0	tnvadk	AWS:Resource
    
    RestAPI0	2795dll430	AWS:RestApi
      
    SecurityGroupIngress0	SecurityGroupIngress0	AWS::EC2::SecurityGroupIngress
    
    TargetGroup	arn:aws:elasticloadbalancing
    

### outputs
APIGWEndpointType	EDGE
APIGatewayEndpoint0	https://2795dll430.execute-api.eu-west-2.amazonaws.com/dev
ClientARNS	arn:aws:iam::838837044885:user/apigw-user
IngressRules	[{"path":"/api/book","backend":{"serviceName":"bookservice","servicePort":80}},{"path":"/api/author","backend":{"serviceName":"authorservice","servicePort":80}}]
RequestTimeout	29000
RestAPIID0	2795dll430


### Cloudformation templates for reference
    AWSTemplateFormatVersion: 2010-09-09
    Outputs:
      APIGWEndpointType:
        Value: EDGE
      APIGatewayEndpoint0:
        Value:
          Fn::Join:
          - ""
          - - https://
            - Ref: RestAPI0
            - .execute-api.
            - Ref: AWS::Region
            - .amazonaws.com/
            - dev
      ClientARNS:
        Value: arn:aws:iam::838837044885:user/apigw-user
      IngressRules:
        Value: '[{"path":"/api/book","backend":{"serviceName":"bookservice","servicePort":80}},{"path":"/    api/author","backend":{"serviceName":"authorservice","servicePort":80}}]'
      RequestTimeout:
        Value: "29000"
      RestAPIID0:
        Value:
          Ref: RestAPI0
    Resources:
      Deployment0:
        DependsOn:
        - Methodapi0
        - Methodapiauthor0
        - Methodapiauthorproxy0
        - Methodapibook0
        - Methodapibookproxy0
        Properties:
          RestApiId:
            Ref: RestAPI0
          StageDescription:
            MethodSettings:
            - {}
          StageName: dev
        Type: AWS:Deployment
      LambdaInvokeRole:
        Properties:
          AssumeRolePolicyDocument:
            Statement:
            - Action:
              - sts:AssumeRole
              Effect: Allow
              Principal:
                Service:
                - apigateway.amazonaws.com
                - lambda.amazonaws.com
            Version: 2012-10-17
          Description:
            Fn::Sub: Lambda Execution Role for stack ${AWS::StackName}
          ManagedPolicyArns:
          - arn:aws:iam::aws:policy/service-role/AWSLambdaRole
          Path: /
          RoleName:
            Fn::Sub: ${AWS::StackName}-LambdaExecutionRole
        Type: AWS::IAM::Role
      Listener:
        Properties:
          DefaultActions:
          - TargetGroupArn:
              Ref: TargetGroup
            Type: forward
          LoadBalancerArn:
            Ref: LoadBalancer
          Port: 80
          Protocol: TCP
        Type: AWS::ElasticLoadBalancingV2::Listener
      LoadBalancer:
        Properties:
          IpAddressType: ipv4
          Scheme: internal
          Subnets:
          - subnet-7d2c7614
          - subnet-db2345a1
          - subnet-b55ce9f9
          Tags:
          - Key: com.github.amazon-apigateway-ingress-controller/stack
            Value:
              Ref: AWS::StackName
          Type: network
        Type: AWS::ElasticLoadBalancingV2::LoadBalancer
      Methodapi0:
        DependsOn:
        - LoadBalancer
        Properties:
          AuthorizationType: AWS_IAM
          HttpMethod: ANY
          Integration:
            ConnectionId:
              Ref: VPCLink
            ConnectionType: VPC_LINK
            IntegrationHttpMethod: ANY
            PassthroughBehavior: WHEN_NO_MATCH
            RequestParameters:
              integration.request.header.Accept-Encoding: '''identity'''
              integration.request.path.proxy: method.request.path.proxy
            TimeoutInMillis: 29000
            Type: HTTP_PROXY
            Uri:
              Fn::Join:
              - ""
              - - http://
                - Fn::GetAtt:
                  - LoadBalancer
                  - DNSName
                - /api
          RequestParameters:
            method.request.path.proxy: true
          ResourceId:
            Ref: Resourceapi0
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Method
      Methodapiauthor0:
        DependsOn:
        - LoadBalancer
        Properties:
          AuthorizationType: AWS_IAM
          HttpMethod: ANY
          Integration:
            ConnectionId:
              Ref: VPCLink
            ConnectionType: VPC_LINK
            IntegrationHttpMethod: ANY
            PassthroughBehavior: WHEN_NO_MATCH
            RequestParameters:
              integration.request.header.Accept-Encoding: '''identity'''
              integration.request.path.proxy: method.request.path.proxy
            TimeoutInMillis: 29000
            Type: HTTP_PROXY
            Uri:
              Fn::Join:
              - ""
              - - http://
                - Fn::GetAtt:
                  - LoadBalancer
                  - DNSName
                - /api/author
          RequestParameters:
            method.request.path.proxy: true
          ResourceId:
            Ref: Resourceapiauthor0
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Method
      Methodapiauthorproxy0:
        DependsOn:
        - LoadBalancer
        Properties:
          AuthorizationType: AWS_IAM
          HttpMethod: ANY
          Integration:
            ConnectionId:
              Ref: VPCLink
            ConnectionType: VPC_LINK
            IntegrationHttpMethod: ANY
            PassthroughBehavior: WHEN_NO_MATCH
            RequestParameters:
              integration.request.header.Accept-Encoding: '''identity'''
              integration.request.path.proxy: method.request.path.proxy
            TimeoutInMillis: 29000
            Type: HTTP_PROXY
            Uri:
              Fn::Join:
              - ""
              - - http://
                - Fn::GetAtt:
                  - LoadBalancer
                  - DNSName
                - /api/author/{proxy}
          RequestParameters:
            method.request.path.proxy: true
          ResourceId:
            Ref: Resourceapiauthorproxy0
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Method
      Methodapibook0:
        DependsOn:
        - LoadBalancer
        Properties:
          AuthorizationType: AWS_IAM
          HttpMethod: ANY
          Integration:
            ConnectionId:
              Ref: VPCLink
            ConnectionType: VPC_LINK
            IntegrationHttpMethod: ANY
            PassthroughBehavior: WHEN_NO_MATCH
            RequestParameters:
              integration.request.header.Accept-Encoding: '''identity'''
              integration.request.path.proxy: method.request.path.proxy
            TimeoutInMillis: 29000
            Type: HTTP_PROXY
            Uri:
              Fn::Join:
              - ""
              - - http://
                - Fn::GetAtt:
                  - LoadBalancer
                  - DNSName
                - /api/book
          RequestParameters:
            method.request.path.proxy: true
          ResourceId:
            Ref: Resourceapibook0
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Method
      Methodapibookproxy0:
        DependsOn:
        - LoadBalancer
        Properties:
          AuthorizationType: AWS_IAM
          HttpMethod: ANY
          Integration:
            ConnectionId:
              Ref: VPCLink
            ConnectionType: VPC_LINK
            IntegrationHttpMethod: ANY
            PassthroughBehavior: WHEN_NO_MATCH
            RequestParameters:
              integration.request.header.Accept-Encoding: '''identity'''
              integration.request.path.proxy: method.request.path.proxy
            TimeoutInMillis: 29000
            Type: HTTP_PROXY
            Uri:
              Fn::Join:
              - ""
              - - http://
                - Fn::GetAtt:
                  - LoadBalancer
                  - DNSName
                - /api/book/{proxy}
          RequestParameters:
            method.request.path.proxy: true
          ResourceId:
            Ref: Resourceapibookproxy0
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Method
      Resourceapi0:
        Properties:
          ParentId:
            Fn::GetAtt:
            - RestAPI0
            - RootResourceId
          PathPart: api
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Resource
      Resourceapiauthor0:
        Properties:
          ParentId:
            Ref: Resourceapi0
          PathPart: author
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Resource
      Resourceapiauthorproxy0:
        Properties:
          ParentId:
            Ref: Resourceapiauthor0
          PathPart: '{proxy+}'
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Resource
      Resourceapibook0:
        Properties:
          ParentId:
            Ref: Resourceapi0
          PathPart: book
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Resource
      Resourceapibookproxy0:
        Properties:
          ParentId:
            Ref: Resourceapibook0
          PathPart: '{proxy+}'
          RestApiId:
            Ref: RestAPI0
        Type: AWS:Resource
      RestAPI0:
        Properties:
          ApiKeySourceType: HEADER
          BinaryMediaTypes:
          - AWS::NoValue
          EndpointConfiguration:
            Types:
            - EDGE
          Name:
            Ref: AWS::StackName
          Policy:
            Statement:
            - Action:
              - execute-api:Invoke
              Effect: Allow
              Principal:
                AWS:
                - arn:aws:iam::838837044885:user/apigw-user
              Resource:
              - '*'
            Version: 2012-10-17
        Type: AWS:RestApi
      SecurityGroupIngress0:
        Properties:
          CidrIp: 172.31.0.0/16
          FromPort: 32085
          GroupId: sg-0b84f70d7a2044e69
          IpProtocol: TCP
          ToPort: 32085
        Type: AWS::EC2::SecurityGroupIngress
      TargetGroup:
        Properties:
          HealthCheckIntervalSeconds: 30
          HealthCheckPort: traffic-port
          HealthCheckProtocol: TCP
          HealthCheckTimeoutSeconds: 10
          HealthyThresholdCount: 3
          Port: 32085
          Protocol: TCP
          Tags:
          - Key: com.github.amazon-apigateway-ingress-controller/stack
            Value:
              Ref: AWS::StackName
          TargetType: instance
          Targets:
          - Id: i-08929555422823722
          UnhealthyThresholdCount: 3
          VpcId: vpc-fa015192
        Type: AWS::ElasticLoadBalancingV2::TargetGroup
      VPCLink:
        DependsOn:
        - LoadBalancer
        Properties:
          Name:
            Ref: AWS::StackName
          TargetArns:
          - Ref: LoadBalancer
        Type: AWS:VpcLink