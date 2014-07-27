def generate_password
 o = [('a'..'z'), ('A'..'Z'),(0..9)].map { |i| i.to_a }.flatten
 (0..10).map { o[rand(o.length)] }.join
end


def create_php_fpm_config
end

def create_data_base
end

def execute_shell(operation_name, ruby_code = false)
  # print "\r\n"
  print "* ".yellow
  print "#{operation_name}".ljust(50)
  yield
  if ruby_code
   print "   OK \r\n".green
  else
    if $?.exitstatus == 0
      print "   OK \r\n".green
    else
      print "   FAILED \r\n".red
      exit
    end
  end
end


def print_colorized args
 args.each do |elem|
  print elem
 end
 print "\r\n"
end
