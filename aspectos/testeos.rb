___________________________________________

Test de Transformacion_iny

No funciona


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

Funciona

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

No funciona, problema del proc

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

