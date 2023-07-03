from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib.auth import logout, authenticate, login
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from home.models import Item_List
from datetime import datetime

def index(request):
    if request.user.is_anonymous:
        return redirect("/login")
    return render(request, 'index.html')

def loginUser(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        user_pages = {
            'owner': '/',
            'daily_manager': '/reportSale',
            'order_manager': '/viewInventory',
            'sales_manager': '/reportSale',
            'revenue_manager': '/viewGraph',
        }
        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            next_url = request.GET.get('next', '/')
            redirect_url = user_pages.get(username, '/')
            return redirect(redirect_url)
        else:
            return render(request, 'login.html')
    return render(request, 'login.html')

@login_required(login_url='/login')
def logoutUser(request):
    logout(request)
    return redirect("/login")

@login_required(login_url='/login')
def addItem(request):
    # code to add item
    if request.method == "POST":
        # print('hi')
        item_type = request.POST.get('item_type')
        manufacturer = request.POST.get('manufacturer')
        vehicle = request.POST.get('vehicle')
        quantity = request.POST.get('quantity')
        price = request.POST.get('price')
        # print(item_type, manufacturer, vehicle)
        if not all([item_type, manufacturer, vehicle, quantity, price]):
            messages.warning(request, 'Please fill all the fields.')
            return redirect('/addItem')
        obj = Item_List(item_type = item_type, manufacturer = manufacturer, vehicle = vehicle, quantity = quantity, price = price, date = datetime.today())
        obj.save()
        messages.success(request, 'Profile details updated.')
    return render(request, 'addItem.html')

@login_required(login_url='/login')
def deleteItem(request):
    if request.method == 'POST':
        item_type=request.POST.get('item_type')
        manufacturer=request.POST.get('manufacturer')
        vehicle=request.POST.get('vehicle')

        # id = dict(request.POST.list()).get('pk')[0]
        # if not all([item_type, manufacturer, vehicle]):
        #     messages.warning(request, 'Please fill all the fields.')
        #     return redirect('/deleteItem')
        print(item_type,manufacturer,vehicle)
        
        item = Item_List.objects.filter(item_type=item_type, manufacturer=manufacturer,vehicle=vehicle)
        if len(item)>0:
            item=item[0]
            print(item)
            item.delete()
            messages.success(request, 'Item deleted successfully.')
        
        return redirect('/deleteItem')
    else:
        items = Item_List.objects.all()
        context = {'items': items}
        return render(request, 'deleteItem.html', context)


@login_required(login_url='/login')
def viewInventory(request):
    # code to view inventory
    items = Item_List.objects.all()
    return render(request, 'viewInventory.html', {'items': items})

@login_required(login_url='/login')
def reportSale(request):
    # code to report sale
    if request.method == 'POST':
        item_type = request.POST['item_type']
        quantity = request.POST['quantity']
        if not all([item_type, quantity, quantity]):
            messages.warning(request, 'Please fill all the fields.')
            return redirect('/reportSale')
        iter = Item_List.objects.filter(item_type = item_type)[0]
        iter.quantity = iter.quantity - (int)(quantity)
        iter.save()
        return render(request, 'reportSale.html')
    
    return render(request, 'reportSale.html')

@login_required(login_url='/login')
def viewGraph(request):
    # code to view graph
    return render(request, 'viewGraph.html')

def logoutUser(request):
    print('trying to log out')
    logout(request)
    print('logged out')
    return redirect("/login")

@login_required(login_url='/login')
def endDay(request):
    # code for end page
    return render(request, 'endDay.html')