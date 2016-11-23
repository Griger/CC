apt_update 'all platforms'

directory '/home/ubuntu/www'

["python-flask", "python-pymongo", "mongodb"].each do |p|
  package p do
    action :install
  end
end
