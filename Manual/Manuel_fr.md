# Manuel du gem `chir`

## CLI Tests

### inputs

#### Simuler l'interruption forcée du programme

Dans l'input, utiliser `EXIT` ou `CTRL-C` (et ses variantes avec tiret plat ou espace) ou `^C`.

#### Pour `Q.yes?`

`with_inputs` peut contenir :

* "o", "y", 1, "true", "yes", "oui" pour retourner `true`
* toute autre valeur retournera `false`

#### Pour `Q.select`

`with_inputs` peut contenir :

* la valeur explicite à retourner

  ~~~ruby
  with_inputs ['valeur explicite']
  ~~~

* la valeur par le nom du menu (non sensible à la casse)

  ~~~ruby
  with_inputs [{name:"le nom du menu"}]
  ~~~

* la valeur par une expression régulière (non sensible à la casse)

  ~~~ruby
  with_inputs [{rname: "men"}] # => le premier menu contenant "men"
  ~~~

* la valeur par un index (1-start) de menu

  ~~~ruby
  with_inputs [{index:2}] # => la valeur du deuxième menu
  ~~~


#### Pour `Q.multiselect`

`with_inputs` peut contenir :

* les valeurs explicites à retourner

  ~~~ruby
  with_inputs [
    ['valeurs','explicites']
  ]
  ~~~

* les valeur par le nom des menus (non sensible à la casse)

  ~~~ruby
  with_inputs [{names:["premier", "deuxième"]}]
  ~~~

* les valeurs par une expression régulière (non sensible à la casse)

  ~~~ruby
  with_inputs [{rname: "men"}] # => Tous les menus contenant "men"
  ~~~

* les valeurs par plusieurs expressions régulières

  ~~~ruby
  with_inputs [{rnames: ["men", "nue"]}] # => Tous les menus contenant "men" ou "nue"
  ~~~

* les valeurs par liste d'index (1-start) de menu

  ~~~ruby
  with_inputs [{index:[2,4]}] # => la valeur du 2e et 4e menu
  ~~~

#### Pour `Q.multiline`

On peut envoyer le texte explicite qu'aurait tapé l'utilisateur :

~~~ruby
with_inputs = ["Le\nTexte\nExplicite"]
~~~

Pour simuler les touches ⌃D (control et D), on peut utiliser au choix : `CTRL-D`, `CTRL D`, `CTRL_D` ou `^D`.

> Note : mais cela revient simplement à mettre un texte vide.
