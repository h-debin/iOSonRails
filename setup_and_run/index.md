作为一个iOS开发，相信很多人和我一样将给自己的app快速的建立后端Server,
把各种高负荷的计算工作都扔到后端，这样app的开发就可以重点放在提高用户体验上。
而作为一个Ruby开发者，我们同样希望自己优雅的Ruby代码不仅仅作为Web app的后端，
更希望自己也能够给自己的后端写iOS的app，没事在拥挤的地铁上无聊时候玩玩。
所以我希望对自己的定义是“一个喜欢Ruby的iOS开发者”，我将会陆续的分享我使用Rails作为
自己app后端的经验，每一次的分享都将是一个完整的项目，也就是你可以直接clone我放在
github上面的项目，然后在自己的本地完美的跑起来，由浅入深。
我想把这一系列称之为“iOS on Rails”

####需求

我们要做一个自己的新闻客户端。

####分析

这就是一个很典型的需要后端支持的app的场景，app不可能去代替后端去完成新闻的获取，信息的处理等工作，app的目的是为终端用户提供最优质的新闻阅读体验。

####实现

* Rails

有很多种方式去为iOS app搭建一个后端，但是也许Rails是最快的方式，
Rails让我们可以在几分钟之内就可以搭建起一个干净的API server：backend-as-a-service.
显然我们app需要的resource是新闻（news），那么我们的REST API应该是这样子:
```
 GET /news
```
对于Rails来说，我们只要进行下面几步就可以达到目的了:
* 创建一个 Rails 项目
```
    rails new server
```
* 创建相应的model和controller
```
    rails g model news
    rails g controller news
```
* 在config/routes.rb中设置路由
```
    Rails.application.routes.draw do
      resources :news
    end
```
现在我们可以查看我们server已经支持了哪些路由了
```
    $ rake routes

     Prefix Verb   URI Pattern              Controller#Action
    news_index GET    /news(.:format)          news#index
               POST   /news(.:format)          news#create
      new_news GET    /news/new(.:format)      news#new
     edit_news GET    /news/:id/edit(.:format) news#edit
          news GET    /news/:id(.:format)      news#show
               PATCH  /news/:id(.:format)      news#update
               PUT    /news/:id(.:format)      news#update
               DELETE /news/:id(.:format)      news#destroy

```
当然我们需要去controller去实现相应的Actioin，为了对 'GET /news' 这个路由，我们需要去实现
index方法，所以我们的 app/controllers/news_controller.rb 如下:
```
class NewsController < ApplicationController
  def index
    render :json => News.all
  end
end
```
给我们的项目添加一点测试数据吧, db/seed.rb
```
1000.times do
  News.create(title:Faker::Name.name,
              link:Faker::Internet.url,
              pub_date:Faker::Time.between(2.days.ago, Time.now),
              image:Faker::Internet.url,
              video:Faker::Internet.url,
              text:Faker::Lorem.paragraph,
              category: Faker::Lorem.word,
              from_site: Faker::Lorem.word)
end

    $ rake db:seed
```
简单的测试一下我们的API。
```
    $ rails s
    $ curl 127.0.0.1/news
```
是不是看到哗啦啦的一大波数据，这就说明基于Rails的一个简单的 API Server就完成了。
