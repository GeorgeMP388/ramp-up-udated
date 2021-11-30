Antes de ejecutar terraform plan o apply, crear una key pairs

En la misma terminal en la que se va a ejecutar terraform,
exportar las variables necesarias para loguearse a la cuenta de AWS
Ejemplo del formato:

    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    export AWS_DEFAULT_REGION=us-west-2

Agregar las variables de terraform referidas a la region y al key-pair creado

    export TF_VAR_AWS_REGION=us-east-1
    export TF_VAR_key_name=internship-key

Luego de haber seteado las anteriores variables, en la misma terminal es posible ejecutar
tanto terraform plan como apply sin problema