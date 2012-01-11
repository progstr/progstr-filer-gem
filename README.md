Progstr Filer is a developer-friendly file hosting platform built specifically for web apps. It lets you easily associate file attachments with your ActiveRecord models and removes the hassle of actually hosting the files yourself.

### Setting up the Ruby gem

Bundler makes that all too easy - add this line to your `Gemfile` to have the gem pulled into your app and required automatically.


    gem "progstr-filer", :require => "progstr-filer"


### Credentials

Progstr Filer uses two keys similar to Amazon's cloud services. The access key is a public string that gets rendered publicly in URL's and web pages. We use it to identify your account. The secret key is used to sign and encrypt sensitive data. You should keep it, well, secret.

Provisioning your add-on with Heroku gets you two environment variables: `PROGSTR_FILER_ACCESS_KEY` and `PROGSTR_FILER_SECRET_KEY`. Add those to your `config/environments/production.rb` file:

    Progstr::Filer.access_key = ENV['PROGSTR_FILER_ACCESS_KEY']
    Progstr::Filer.secret_key = ENV['PROGSTR_FILER_SECRET_KEY']
 

### Defining an uploader

Every attachment can have a specific set of options that take effect while uploading and manipulating it. Those settings get configured via your own class that will extend `Progstr::Filer::Uploader`. You could store uploader classes in your `app/uploaders` folder. Here is a sample class:

    class AvatarUploader < Progstr::Filer::Uploader
      #uploader options
    end


### Associating uploaders with your models

Progstr Filer extends ActiveRecord models and lets you use the `has_file` method in class definitions. Here is a User model class that has an avatar image managed as a Progstr Filer attachment via its `avatar` property:

    class User < ActiveRecord::Base
        has_file :avatar, AvatarUploader
    end


Note: make sure your database table has an `avatar` column created already. Future versions of the `progstr-filer` gem will let you generate migrations automatically.

### Feeding data to your uploaders

That is easy - all you need is assign a Ruby File object to the uploader property and save the model object:

    @user.avatar = uploaded_image_file
    @user.avatar.save 


Rails can get most of the job done for you automatically if you create a file upload form:

    <div class="field">
      <%= f.label :avatar %>
      <%= f.file_field :avatar %>
    </div>


...and create your model from the params hash:

    @user = User.new(params[:user])
    @user.save


### Generating URLs for files

Just use the `url` method on your attachments, say `@user.avatar.url`. Here is a sample view that generates an `img` tag pointing to the avatar image:

    <p>
      <b>Avatar:</b><br>
      <%= image_tag @user.avatar.url, :style => "max-width: 600px; margin: 10px 0px;" %>
    </p>

### Validation

Users may upload all types of files to your application and it might be a good idea to restrict that to the set of files that your application knows how to process. For example it would not be a good idea to allow non-image file types as an avatar picture. It might be a good idea to disable executable content that might spread malware too. To help with that the `progstr-filer` gem currently supports attachment validation according to an extension whitelist through the `validates_file_extension_of` method that is available to model objects:

    class User < ActiveRecord::Base
      has_file :avatar, AvatarUploader
      validates_file_extension_of :avatar, :allowed => ["jpg", "png"]
    end

In addition you can restrict the file size using `validates_file_size_of`:

    class User < ActiveRecord::Base
      has_file :avatar, AvatarUploader
      validates_file_size_of :avatar, :less_than => 1 * 1024 * 1024
    end

The example above will not allow files larger than 1 MB. You can specify a lower bound using the `:greater_than` option or even pass a numeric range using the `:in` option.

Of course, requiring users to always upload a file when saving a model object, use the Rails built-in `validates_presence_of` validator:

    class User < ActiveRecord::Base
      has_file :avatar, AvatarUploader
      validates_presence_of :avatar
    end

You can pass a custom error message for all validators using the `:message` option.

### Deleting stale files

Every time you set a new file and save your model, the old file will get scheduled for deletion. The same happens when you `destroy` your model. Note that calling `delete` for your model will not delete any associated files.

### Source code

The `progstr-filer` [gem](https://rubygems.org/gems/progstr-filer) is open source and its code is hosted on [Github](https://github.com/progstr/progstr-filer-gem).

All the techniques outlined in this document are available as a fully-functional Rails project on [Github](https://github.com/progstr/progstr-filer-demo) too.
