Notas:
- A las clases de tipo metodo se puede hacer un to_proc

# Este test confirma que se puede hacer un instance eval en si mismo
class T_eval

   def transformar()
         @redefinir_metodo = proc {
            def zzz
               puts "hola"
            end
         }
         instance_eval(&@redefinir_metodo)

   end

end

teval = T_eval.new
teval.transformar



# Este test confirma que se puede hacer un instance eval en si mismo
class T_eval2

   def transformar()
      @parametros = "asd"
      @definir_metodo = proc {
         |x|
         def zzz x
            puts x
         end
      }

     @redefinir_metodo = proc {
        @definir_metodo.call(@parametros)
     }

      instance_eval(&@redefinir_metodo)

   end

end

teval2 = T_eval2.new
teval2.transformar
teval2.zzz


# Este test confirma que se puede hacer un instance eval en si mismo
class T_eval3

   def transformar()

      @parametros = "ejemplo_parametro"

      @metodo_a_inyectar = proc {
         |args|
         def zzz args
            puts args
         end
      }

      redefinir_metodo = proc {
         @metodo_a_inyectar.call(@parametros)
      }

      # ver como cambiar lo del self.
      instance_eval(&redefinir_metodo)

   end

end

t_eval3 = T_eval3.new
t_eval3.transformar
t_eval3.zzz "ola de mars"




___________________________________________

Test de Transformacion_iny

Test no funciona


class MiClase
  def hace_algo(p1, p2)
    p1 + '-' + p2
  end
  def hace_otra_cosa(p2, ppp)
    p2 + ':' + ppp
  end
end


hash = { "p2 "=> "asd"}


transformacion_prueba = Transformacion_iny.new hash, MiClase.instance_method(:hace_algo)

a = MiClase.new

bloque = proc {
   transformacion_prueba.transformar
}

a.class.send(:define_method, :saludar, transformacion_prueba.transformar.to_proc)



instancia = MiClase.new
# este caso explota
# instancia.hace_algo("foo")
# "foo-bar"

instancia.hace_algo("foo", "foo")
# "foo-bar"

instancia.hace_otra_cosa("foo", "foo")
# "bar:foo"

___________________________________________

Test de Transformacion_red

Esto funciona

class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adiosin, " + x
  end
end

param = B.new
transformacion_prueba = Transformacion_red.new(param, :saludar)

a = A.new

bloque = proc {
   transformacion_prueba.transformar
}

# Esto me devuelve el unbound method
# a.instance_eval(&bloque)

a.class.send(:define_method, :saludar, transformacion_prueba.transformar.to_proc)

a.saludar("Mundo")
# "Adiosin, Mundo"


___________________________________________

Test de Transformacion_log

class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adiosin, " + x
  end
end

param = B.new
a = A.new

bloque = proc { puts " funciona " }

transformacion_prueba = Transformacion_log.new("before", B.instance_method(:saludar), &bloque)

a.class.send(:define_method, :saludar, transformacion_prueba.transformar)



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