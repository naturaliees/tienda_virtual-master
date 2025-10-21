# renta/models.py

from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils.translation import gettext_lazy as _

# --- Modelo Artista (Tabla Artista) ---
class Artista(models.Model):
    id_artista = models.BigAutoField(primary_key=True)
    nombre_artista = models.CharField(max_length=32, null=False)
    apellido_artista = models.CharField(max_length=32, null=False)

    class Meta:
        managed = True
        db_table = 'Artista'

    def __str__(self):
        return f'{self.nombre_artista} {self.apellido_artista}'

# --- Manager personalizado para el Cliente ---
# Es necesario para usar un modelo de usuario personalizado en Django/DRF
class ClienteManager(BaseUserManager):
    def create_user(self, correo, password=None, **extra_fields):
        if not correo:
            raise ValueError('El correo es obligatorio')
        cliente = self.model(correo=self.normalize_email(correo), **extra_fields)
        cliente.set_password(password)
        cliente.save(using=self._db)
        return cliente

    # No necesitamos un superuser por ahora, solo user básico.
    # Definiendo create_superuser es buena práctica, pero lo omitimos por simplicidad.


# --- Modelo Cliente (Tabla Cliente) ---
class Cliente(AbstractBaseUser, PermissionsMixin):
    id_cliente = models.BigAutoField(primary_key=True)
    nombres = models.CharField(max_length=32, null=False)
    apellidos = models.CharField(max_length=32, null=False)
    correo = models.CharField(max_length=64, unique=True, null=False) # Agregamos unique para autenticación

    # La contraseña está incluida en AbstractBaseUser y se gestiona con set_password()

    prg_validacion = models.CharField(max_length=128, null=False)
    rp_validacion = models.CharField(max_length=128, null=False)
    estado = models.SmallIntegerField(null=False, default=1) # Asumimos un default

    # Campos requeridos por AbstractBaseUser
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)

    # Definición de campos para autenticación
    USERNAME_FIELD = 'correo' # Usaremos el correo para el login
    REQUIRED_FIELDS = ['nombres', 'apellidos'] # Campos requeridos al crear usuario

    objects = ClienteManager()

    class Meta:
        managed = True
        db_table = 'Cliente'

    def __str__(self):
        return self.correo

# Ahora, configura Django para usar este modelo para la autenticación
# En config/settings.py, agrega: AUTH_USER_MODEL = 'renta.Cliente'


# --- Modelo Disco (Tabla Disco) ---
class Disco(models.Model):
    id_disco = models.BigAutoField(primary_key=True)
    titulo = models.CharField(max_length=128, null=False)
    sinopsis = models.TextField(null=True)
    # double precision en SQL Server es FloatField en Django
    duracion = models.FloatField(null=True)
    director = models.CharField(max_length=128, null=False)
    clasificacion = models.CharField(max_length=8, null=True)
    genero = models.CharField(max_length=8, null=True) # char(8)
    portada = models.CharField(max_length=256, null=True)
    costo_venta = models.DecimalField(max_digits=6, decimal_places=2, null=False)
    costo_renta = models.DecimalField(max_digits=6, decimal_places=2, null=False)
    tamanio = models.FloatField(null=True)
    fecha_agregado = models.DateTimeField(null=True)

    class Meta:
        managed = True
        db_table = 'Disco'

    def __str__(self):
        return self.titulo

# --- Modelo de Relación Muchos a Muchos (Tabla Disco_Artista) ---
class DiscoArtista(models.Model):
    id_disco_art = models.BigAutoField(primary_key=True)
    # Foreign Keys
    id_disco = models.ForeignKey(Disco, on_delete=models.CASCADE, db_column='id_disco')
    id_artista = models.ForeignKey(Artista, on_delete=models.CASCADE, db_column='id_artista')

    class Meta:
        managed = True
        db_table = 'Disco_Artista'
        unique_together = ('id_disco', 'id_artista') # Previene duplicados

    def __str__(self):
        return f'Disco: {self.id_disco_id}, Artista: {self.id_artista_id}'


# --- Modelo Renta (Tabla Renta) ---
class Renta(models.Model):
    id_renta = models.BigAutoField(primary_key=True)
    id_disco = models.ForeignKey(Disco, on_delete=models.CASCADE, db_column='id_disco')
    id_cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE, db_column='id_cliente')
    fecha_renta = models.DateTimeField(null=False)
    fecha_dev = models.DateTimeField(null=False)
    precio_renta = models.DecimalField(max_digits=6, decimal_places=2, null=False)
    impuesto = models.DecimalField(max_digits=6, decimal_places=2, null=False)
    total = models.DecimalField(max_digits=6, decimal_places=2, null=False)

    class Meta:
        managed = True
        db_table = 'Renta'

    def __str__(self):
        return f'Renta {self.id_renta} - Disco {self.id_disco_id}'


# --- Modelo Venta (Tabla Venta) ---
class Venta(models.Model):
    id_venta = models.BigAutoField(primary_key=True)
    id_disco = models.ForeignKey(Disco, on_delete=models.CASCADE, db_column='id_disco')
    id_cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE, db_column='id_cliente')
    fecha_venta = models.DateTimeField(null=False)
    precio_venta = models.DecimalField(max_digits=6, decimal_places=2, null=False)
    impuesto = models.DecimalField(max_digits=6, decimal_places=2, null=False)
    descuento = models.DecimalField(max_digits=6, decimal_places=2, null=True)
    total_venta = models.DecimalField(max_digits=6, decimal_places=2, null=False)

    class Meta:
        managed = True
        db_table = 'Venta'

    def __str__(self):
        return f'Venta {self.id_venta} - Disco {self.id_disco_id}'