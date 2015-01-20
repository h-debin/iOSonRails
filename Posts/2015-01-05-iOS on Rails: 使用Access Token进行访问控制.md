---
title: iOS on Rails&#58; 使用 Access Token 进行访问控制
layout: post
categories: Objective-C Ruby
tag: ‘iOS on Rails’
---

Rails 作为我们 App 后端 API Server，为我们的 App 提供便利的 API 访问的同时，也肩负着保护我们数据安全的责任。如果我们的 API 不打算开放给别人使用的话，我们一般都会对 API 的访问进行一定程度的控制，特别当我们的数据要求一定的私密性，或者我们不希望我们自己辛辛苦苦而得到的数据，不想被竞争对手轻而易取的获取的话，我们必须对访问进行控制，本文我们就来说说如何使用 Access Token 来实现对访问的控制。

#### 用户: 先别强制要求我们注册好不好

对于一个 Web 应用来说，数据可以分为两类: 用户数据和非用户数据。对于用户数据来说，私密性显然是排在首位的，一般只有用户本身才用访问的权限。而非用户数据，也就 Web 服务本身提供的数据。对我们这个新闻 App 来说，我们的新闻就是非用户数据，而用户的信息，比如阅读习惯爱好，订阅类别等等则属于用户私有数据。所以对于用户来说，注册登录之后才能访问用户数据，而新闻则不需要用户去注册登录之后就可以去阅览。

从我个人的角度来说，我特别不喜欢一上来就要求用户去注册，否则不能使用服务，甚至很多 App 本来就没有什么社交元素，还是非得让用户去注册一下，又要用户，又要 Email，还得设置高强度的密码，过程很繁琐，太反人类了。其实正确的做法是让用户随意的先试用，App 的良好体验自然而然让用户去自己注册了。

#### 开发者: 其实我只想保护我们的成果

由于新闻材料是我们千辛万苦去爬过来，而且费劲心思去处理和分类的，所以我们不希望 API 直接暴露给别人使用，所以我们限制所有对我们 API 的访问必须进行一定认证，对于一般的应用来说，采用 Access Token 的方式就够了。

<pre>
GET /news
{
	"token": "23243dfdkdgj23432j43k2432jfdf",
	"uuid": "23249fjdsfk94jskfjd044rjekjgsd"
}
</pre>

现在就让我们来实现一个基础的 Access Token 机制，使我们的 iOS App 和 Rails API 自由安全的交流吧。

#### 实现

##### Rails

* Action Controller

在 Rails 中，无论是注册登录，还是 API 访问的控制，过滤器 (Filter) 都是最简单直接的方式， 在我们的 Rails 的 ApplicationController 中加入一个验证 token 的过滤器吧。
<pre>
before_action :require_token_authentication

private
  def require_token_authentication
	unless token_autentication
	  flash[:error] = "Please use a valid token to access"
	  render :status => 511, :json => { status: "require token to access" }
	end 
  end 

  def token_autentication									
	device_uuid = params[:uuid]
	token = params[:token]
	if User.find_by(device_uuid: device_uuid,  token: token)
	  return true
	end 
	return false
  end 
</pre>

可以看出，在执行任何的 action 之前，我们都会先去验 token 和 uuid 是否匹配，如果不匹配，则返回 511 的 error code。对于任何访问我们 API 的设备都必须提供有效的 uuid 和 token，所以任何想使用我们 API 的客户端，首先要用自己的 uuid 去进申请一个 access token，然后才能进行 API 的访问。

* User Model

让我们给我们的后端添加一个 User 的 Model， 这样做的目的是为了更好的管理我们的用户 (客户端)，在后续的功能设计中可以根据 User 信息的统计分析做出更多适应性的 feature。而且 Rails 的 Migration 功能实在是太好用了，我们并不用一开始就确定我们的 User Model 所需要包含的所有信息。就目前来说我们只要可以有 uuid 和 token 属性就可以了。所以我们可以创建一个简单的 migration。

<pre>
class CreateUsers < ActiveRecord::Migration	 
  def change
	create_table :users do |t| 
	  t.text "device_uuid"
	  t.text "token"
	  t.timestamps
	end 
  end 
end
</pre>

* access token 申请

我们建立一个独立的路由来方便我们的 App 客户端进行 access token 的申请。在我们的 Rails 的 config/routes.rb 中添加:
<pre>
match '/request_access_token', to:'user#create', via: [:post]
</pre>
然后在 User 的控制器中 app/controllers/user_controller.rb 实现 access token 的生成和保存，而实际上每一个用户 (客户端) 会对应着一个user，所以我们直接在 create 动作中来完成是合理的。
<pre>
class UserController < ApplicationController	
  # ++
  # skip token check when user request a token
  # ++
  skip_before_action :require_token_authentication, :only => [:create]

  def create
	uuid = params[:uuid]
	token = Digest::MD5.hexdigest uuid
	if User.create(device_uuid: uuid, token: token)
	  render :json => { token: token } and return
	end 

	render :json => "token already taken, please use your token to access", :status => 511 
  end 
end
</pre>
需要注意的是所有的控制器实际上对继承自 ApplicationController，而我们在 ApplicationController 中定义所有的 action 都必须经过 acccess token 验证的步骤，当用户需要去申请 access token 时候是没有办法通过 access token 的验证，所以我们在上面的 access token 的申请中忽略掉 require_token_authentication 的验证。

#### iOS

当我开始进行 iOS 开发的时候，我发现自己无法很好的重用自己写过的代码，开始开发下一版本的时候，自己相当于又重写了一次 App，造成这样的原因有两个方面:

* 想法太多

什么都想去表达，UI 变了又变，功能变了又变，什么功能呢都想做，这样的结果是什么功能都做不好，而且产品失去了灵魂，所以现在每次开始开发新功能之前，我都尽量压缩 feature 的数目，当 feature 少到一定程度了之后，我才发现其实那些才是我内行真正想去实现。

* 设计模式

没有认证的思考设计模式是否合适，甚至很多时候仅仅为了完成而仅仅是代码的堆积，没有任何的设计，所以导致了代码大量的冗余，没有任何的美感，quick and dirty 不是我们内心想要，我是自己对东西要求十分严格的人，我会尽自己最大的努力去实现自己当下觉得最美的东西，简单事美，但美并不简单。

好吧，废话少说吧。

#####  HTTP 的两个库

对于任何设计到网路的 App，我都十分的推荐使用两个库: AFNetworking 和 Restkit。 AFNetworking 试用于任何的网络相关的场景，AFNetworking 是 [Matt](https://github.com/mattt) 大神的作品，没有 AFNetworking，iOS的开发在网络操作方面不知道要累多少倍。 而 Restkit 建立在 AFNetworking 之上，可以和后端的 REST Service 无缝的结合，良好的 Core Data 支持以及优秀的 Object mapping 让我们可以省去很多的时间。 本文我们使用 AFNetworking，在后续我们会有专门一节来讲解 RESTful Web Service，到时候我们可以细细的了解 Restkit 框架.

##### iOS 设备的唯一性标识

在 iOS 5 中我们可以使用 UDID (Unique Device Identifie) 来真正标识设备的唯一性。后来 Apple 禁掉了。在 iOS 6 中人们开始使用 Mac 地址来作为设备的唯一性标识，后来 Apple 又禁掉了。后来人们有的使用广告标志符。我自己的做法是使用 UUID (Universally Unique Identifier), 通用唯一识别码。它是让分布式系统中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端来做辨识资讯的指定。这样，每个人都可以建立不与其它人冲突的 UUID。在此情况下，就不需考虑数据库建立时的名称重复问题。苹果公司建议使用UUID为应用生成唯一标识字符串。获取 UUID 之后存入 KeyChain，后续使用到 UUID 的时候去 KeyChain 中获取，这样可以达到标识设备唯一性的目的。

* 获取 UUID
<pre>
- (NSString *)getUUIDFromDevice {
	CFUUIDRef puuid = CFUUIDCreate(nil);
	CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
	return (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
}
</pre>

* 存入KeyChain
<pre>
- (void)saveUUIDToKeyChain:(NSString *)uuid {
	UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"api.newsi.care"];
	[store setString:uuid forKey:@"uuid"];
	[store synchronize];
}
</pre>

* 从 KeyChain 获取 UUID

<pre>
- (NSString *)getUUIDFromKeyChain {
	UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"api.newsi.care"];
	return store[@"uuid"];
}
</pre>

* 定制 HTTPClient

我们需要实现一个 HTTPClient 去肩负着我们的所有的 HTTP 操作，所以我们的 HTTPClient 大约是这样子的。

<pre>
@interface HTTPClient : NSObject

+ (id)sharedHTTPClient;

- (void)get:(NSString *)url
  parameter:(NSDictionary *)params
	success:(void (^)(id JSON))successHandler
	failure:(void (^)(NSError *error))failureHandler;

- (void)post:(NSString *)url
   parameter:(NSDictionary *)params
	 success:(void (^)(id JSON))successHandler
	 failure:(void (^)(NSError *error))failureHandler;

- (void)getWithAccessToken:(NSString *)url
					  uuid:(NSString *)uuid
					 token:(NSString *)token
				 parameter:(NSDictionary *)params
				   success:(void (^)(id JSON))successHandler
				   failure:(void (^)(NSError *error))failureHandler;

- (void)postWithAccessToken:(NSString *)url
					  uuid:(NSString *)uuid
					  token:(NSString *)token
				  parameter:(NSDictionary *)params
					success:(void (^)(id JSON))successHandler
					failure:(void (^)(NSError *error))failureHandler;

@end
</pre>

可以看到我们大量的使用上一篇文章中提到的 Block，当然最核心是我们的 GET 和 POST 都有携带着 access token，首先我们向 API Server 申请一个和 UUID 配对的 access token，然后在每一次的数据请求中都携带 access token。

### 最后
你依然可以在 GitHub 上看我们的完整代码示例.
[https://github.com/metrue/iOSonRails](https://github.com/metrue/iOSonRails)



