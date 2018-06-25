### ASKED : rails new asked / rails s -b 0.0.0.0

* posts 컨트롤러 `rails g controller posts index new create show edit update destroy`

  * `index`

    * 모든 것을 보여준다.

  * Create : `new` `create`

    * `new`

      form을 보여준다.

    * `create`

      * form 데이터를 받는다. (params)
      * Post에 Create 한다.

  * Read : `show`

    * Post 중에 하나를 선택한다.

  * Update : `edit` `update`

    * `edit`

      form을 보여준다

    * `update`

      * form 데이터를 받는다. (params)
      * Post 중에 하나를 선택한다.
      * update한다.

  * Delete : `destroy`

    * Post 중에 하나를 선택한다.
    * 삭제한다.

* users 컨트롤러 `rails g controller users index new create`

* post 모델 `rails g model post username:string title:string content:text`

  * string `username`
  * string `title`
  * text `content`

* user 모델

  * string `username`
  * string `email`
  * string `password`



#### [Rails 기본 라우팅](https://guides.rorlab.org/routing.html#%EB%A6%AC%EC%86%8C%EC%8A%A4-%EA%B8%B0%EB%B0%98%EC%9C%BC%EB%A1%9C-%EB%9D%BC%EC%9A%B0%ED%8C%85%ED%95%98%EA%B8%B0-rails%EC%9D%98-%EA%B8%B0%EB%B3%B8)

```ruby
# config/routes.rb
# index
get 'posts' => 'posts#index'
# CRUD - C
get 'posts/new' => 'posts#new'
post 'posts' => 'posts#create'
# CRUD - R
get 'posts/:id' => 'posts#show'
# CRUD - U
get 'posts/:id/edit' => 'posts#edit'
put 'posts/:id/' => 'posts#update'
# CRUD - D
delete 'posts/:id' => 'posts#destroy'
```

```ruby
resources :posts
```

* REST API를 구성하는 기본 원칙
  1. URL은 정보의 자원을 표현한다.
  2. 자원에 대한 행위는 HTTP method(verb)로 표현한다.

#### form에서 post 요청 보내기

```erb
<!-- app/views/posts/new.html.erb -->
<form action="/posts" method="post">
    ..
    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
    ..
</form>
```

```ruby
# app/controllers/application_controller.rb
protect_from_forgery with: :exception
```

* form post 요청에서 token이 없으면, 오류가 발생함.
  토큰을 사용하는 이유는 CSRF 공격을 방지하기 위해서임.

#### put, delete 요청 보내기

```erb
<!-- app/views/posts/edit.html.erb -->
<form action="/posts/<%=@post.id%>" method="post">
    ..
    <input type="hidden" name="_method" value="put">
    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
    ..
</form>
```

```erb
<a href="/posts/<%=@post.id%>" data-method="delete" data-confirm="정말 삭제할래?">삭제하기</a>
```

#### [Database relation(association)](https://guides.rorlab.org/association_basics.html)

* 1:多 (1:N)

  User(1) - Post(N) 관계 설정.

  유저는 많은 게시글을 가지고 있고,
  게시글은 특정 유저에 속하기 때문.

* 실제 코드 적용

* 1. 객체 관계 설정

  ```ruby
  # app/model/user.rb
  class User < ActiveRecord::Base
      has_many :posts
  end
  ```

  ```ruby
  # app/model/post.rb
  class Post < ActiveRecord::Base
      belongs_to :user
  end
  ```

  2. 데이터베이스 관계 설정 -> `rake db:migrate`

     ```ruby
     # db/migrate/20180625_create_posts.rb
     ..
     	t.string :title
     	t.text :content
     	t.integer :user_id  # Foreign key
     #   t.reference :user_id
     ..
     ```



* 실제로 관계를 활용하기

  1. 유저가 가지고 있는 모든 게시글

  ```ruby
  # 1번 유저의 모든 글
  @user_posts = User.find(1).posts
  # 그 사람이 쓴 글의 갯수
  User.find(1).posts.count
  ```

  2. 특정 게시글에서 작성한 사람 정보 출력

  ```ruby
  # 1번 글의 유저 작성자 이름
  Post.find(1).user.username
  ```

#### login

```ruby
# app/controllers/sessions_controller.rb
def new # get '/login'
end

def create # post '/login'
    #로그인 성공시
   session[:user_id] = id
end

def destroy # get '/logout'
   session.clear
end
```

#### before filter : 컨트롤러

```ruby
# app/controllers/posts_controller.rb
# authorize 메소드를 실행하는데, 여기 모든 액션 중에 index를 제외하고 실행
before_action :authorize, except: [:index]
```

```ruby
# app/controllers/application_controller.rb
def authorize
   unless current_user
       flash[:alert] = "로그인 해주세요"
       redirect_to '/'
   end
end
```

#### helper method

```ruby
# app/controllers/application_controller.rb

# view에서도 활용가능한 메소드로 만드는 법
helper_method :current_user

def current_user
   # @user에 값이 있으면, 디비에 쿼리를 날리지 않는다.
   @user ||= User.find(params[:id]) if session[:user_id]
end
```

* 뷰에서 활용

  ```erb
  <% if current_user %>
  	<p><%= current_user.username %></p>
  	<a href="/logout">로그아웃</a>
  <% else %>
  	<a href="/login">로그인</a>
  	<a href="/signup">회원가입</a>
  <% end %>
  ```
