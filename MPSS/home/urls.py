from django.contrib import admin
from django.urls import path
from home import views

admin.site.site_header = "MPSS Admin"
admin.site.site_title = "MPSS Admin Portal"
admin.site.index_title = "Welcome to MPSS Portal"

urlpatterns = [
    path('login', views.loginUser, name="login"),
    path('', views.index, name="home"),
    path('logout', views.logoutUser, name="logout"),
    path("addItem", views.addItem, name="addItem"),
    path("deleteItem", views.deleteItem, name="deleteItem"),
    path("viewInventory", views.viewInventory, name="viewInventory"),
    path("reportSale", views.reportSale, name="reportSale"),
    path("viewGraph", views.viewGraph, name="viewGraph"),
    path('endDay', views.logoutUser, name="endDay"),
]