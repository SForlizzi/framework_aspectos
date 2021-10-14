
___________________________________________
Esto funciona

class A

end

a = proc {
   define_method :fuego do
      puts "fuego"
   end
}

A.instance_eval(&a)
A.fuego
___________________________________________

Esto funciona

class Person

end

class Developer < Person
end

persona = Person.new
code = proc { |greetings| puts greetings; puts self }

persona.instance_exec 'Good morning', &code

___________________________________________

Esto funciona tambien


class A

end

unBloque = proc {
   |var|
   define_method :pruebita do
      puts var
   end
}

var_test = A.new

var_test.instance_exec 'Good morning', &code

A.new.prueba
___________________________________________