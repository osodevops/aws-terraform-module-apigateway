### Apigateway

This repository contains the "source" code for the Api Gateway, VPC link, Custom
Domain, network load balancer

Custom Domain

Apigateway

VPCLink

LoadBalancer

--- within the apigateway
RestAPI0, Type:RestApi

  Resourceapi0, Type:Resource => Methodapi0, Type::Method

    Resourceapibook0, Type:Resource => Methodapibook0, Type:Method 

      Resourceapibookproxy0:, Type:Resource => Methodapibookproxy0, Type:Method

    Resourceapiauthor0, Type: ApiGateway::Resource => Methodapiauthor0, Type:Method

      Resourceapiauthorproxy0:, Type:Resource => Methodapiauthorproxy0, Type:Method

Api Gateway pointing to a load balancer having internal domain name.
Create Custom Domainname in the API Gateway Console - because we are using Virtual Hosts in Nginx based on the incoming url we will have to make the API available on that URL.
at the same time configure the certificate
when we select edge optimized cloudfront is automatically included - then we need to create records in route53 which point to this cloudfront distribution


  Apigateway (service with name reference api-95d8427d)
Deployment0	7ahgto	AWS:Deployment
Listener	arn:aws:elasticloadbalancing:eu-west-2:670824338614:listener/net/api-9-LoadB-RCE24E8FTK2A/e40102e887d0e5ae/9346b241d4a5f4a0	AWS::ElasticLoadBalancingV2::Listener
  LoadBalancer	arn:aws:elasticloadbalancing:eu-west-2:670824338614:loadbalancer/net/api-9-LoadB-RCE24E8FTK2A/e40102e887d0e5ae	AWS::ElasticLoadBalancingV2::LoadBalancer
  Resourceapi0	1a8od8	AWS:Resource	CREATE_COMPLETE	-
  Resourceapiauthor0	8dqylq	AWS:Resource	CREATE_COMPLETE	-
  Resourceapiauthorproxy0	rzp65v	AWS:Resource	CREATE_COMPLETE	-
  Resourceapibook0	yg6a1l	AWS:Resource	CREATE_COMPLETE	-
  Resourceapibookproxy0	tnvadk	AWS:Resource	CREATE_COMPLETE	-
  RestAPI0	2795dll430	AWS:RestApi	CREATE_COMPLETE	-
SecurityGroupIngress0	SecurityGroupIngress0	AWS::EC2::SecurityGroupIngress	CREATE_COMPLETE	-
TargetGroup	arn:aws:elasticloadbalancing:eu-west-2:670824338614:targetgroup/api-9-Targe-DWOAGRSGSRV/ec3915b182f4fabe	AWS::ElasticLoadBalancingV2::TargetGroup	CREATE_COMPLETE	-
VPCLink	vawurb	AWS:VpcLink

### outputs
APIGWEndpointType	EDGE
APIGatewayEndpoint0	https://2795dll430.execute-api.eu-west-2.amazonaws.com/dev	-	-
ClientARNS	arn:aws:iam::670824338614:user/apigw-user
IngressRules	[{"path":"/api/book","backend":{"serviceName":"bookservice","servicePort":80}},{"path":"/api/author","backend":{"serviceName":"authorservice","servicePort":80}}]	-	-
RequestTimeout	29000
RestAPIID0	2795dll430


https://github.com/clouddrove/terraform-aws-api-gateway
Terraform code to build API Gateway, VPC link, network load balancer (private) and custom domainname (Route53 records) with cloudfront link.
Also check the nginx documentation: https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-1/



## Cloudformation templates
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
    Value: arn:aws:iam::670824338614:user/apigw-user
  IngressRules:
    Value: '[{"path":"/api/book","backend":{"serviceName":"bookservice","servicePort":80}},{"path":"/api/author","backend":{"serviceName":"authorservice","servicePort":80}}]'
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
            - arn:aws:iam::670824338614:user/apigw-user
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