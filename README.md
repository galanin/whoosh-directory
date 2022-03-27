<a href="http://xn--d1acvi.xn--80aehokqgebjbhdy3e.xn--p1ai/">Live demo in Russian</a>

Icons made by 
* <a href="https://www.flaticon.com/authors/gregor-cresnar" title="Gregor Cresnar">Gregor Cresnar</a>
* <a href="https://www.flaticon.com/authors/smashicons" title="Smashicons">Smashicons</a>
* <a href="https://www.freepik.com/" title="Freepik">Freepik</a>
* <a href="https://www.flaticon.com/authors/eucalyp" title="Eucalyp">Eucalyp</a>
* <a href="https://www.flaticon.com/authors/vectors-market" title="Vectors Market">Vectors Market</a> (and modified by me) 
* <a href="https://www.flaticon.com/authors/good-ware" title="Good Ware">Good Ware</a> (and modified by me)
* <a href="https://www.flaticon.com/authors/maxim-basinski" title="Maxim Basinski">Maxim Basinski</a> (and modified by me)
* <a href="https://www.flaticon.com/authors/google" title="Google">Google</a>

from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> are licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a>


# How to start development
* Install LTS
 NodeJS
* Install latest
 stable Ruby
* Install MongoDB

### Ruby dependencies:
Install Bundler
 if not installed
~~~
gem install bundler
~~~
Install ruby dependencies

~~~
bundler install
~~~

### NodeJS dependencies:
Install Yarn
~~~
npm install yarn -g
~~~
~~~
yarn install
~~~

### Configure MongoDB:
Copy and rename mongoid
 config file
~~~
cp config/mongoid.yml.sample config/mongoid.yml
~~~
Copy and rename .env
~~~
cp example.env .env
~~~

Change ***STAFF_DEMO_FILE_PATH*** in ***.env*** file to path of your demo data

Import demo data in DB
~~~
bundle exec rake full_import"[Demo,ru]"
~~~

### Prepare Puma config and .env
Copy and rename puma.rb config
~~~
cp puma.rb.example tmp/puma.rb
~~~
Create folders for state and pid
~~~
mkdir tmp/pids
~~~
Finally in ***tmp/puma.rb*** and ***.env*** change paths to your project folder.

### Start dev server
Start API
~~~
bunlder exec -C tmp/puma.rb
~~~

Start Web server

~~~
npm run dev:start
~~~

Deployment

```shell
bundle exec cap demo2 puma:systemd:config puma:systemd:enable
```
