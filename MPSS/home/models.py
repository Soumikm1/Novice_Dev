from django.db import models

class Item_List(models.Model):
    item_type = models.CharField(max_length=128)
    manufacturer = models.CharField(max_length=128)
    vehicle = models.CharField(max_length=12)
    quantity = models.IntegerField()
    price = models.IntegerField()
    date = models.DateField()
    #date = models.DateField()
    def __str__(self):
        return self.item_type
    