from flask import Flask,request,render_template,redirect,url_for,flash,session,Response
from otp import gen_otp
from cmail import send_mail
from stoken import entoken,dtoken
from flask_session import Session
import pdfkit
import mysql.connector 
import bcrypt
import os
import razorpay
import re
client=razorpay.Client(auth=("rzp_test_IW39YgU8i2HhFs",
"gtE4ty01rVjtxpu9BbTdgNrR"))
config = pdfkit.configuration(wkhtmltopdf=r"C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe")
app=Flask(__name__)
app.config['SESSION_TYPE']='filesystem'
Session(app)
app.secret_key='codegnan@2025'
mydb=mysql.connector.connect(user='root',host='localhost',password='admin',db='ecomdb')

def is_valid_password(password):
    # Password must contain at least one lowercase, one uppercase, one digit, and one special character, and be at least 8 characters long
    pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$'
    return re.match(pattern, password)

@app.route('/')
def home():
    return render_template('welcome.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/privacy')
def privacy():
    return render_template('privacy.html')

@app.route('/return_policy')
def return_policy():
    return render_template('return-policy.html')

@app.route('/index')
def index():
    try:
        cursor=mydb.cursor(buffered=True)
        cursor.execute('select bin_to_uuid(itemid),item_name,description,item_cost,item_category,item_quantity,created_at,imgname from items')
        items_data=cursor.fetchall()
    except Exception as e:
        print(f'Error is {e}')
        flash('Could not fetch the items')
        return redirect(url_for('index'))
    else:
        return render_template('index.html',items_data=items_data)
    return render_template('index.html')

import re

def is_valid_password(password):
    # Password must contain at least one lowercase, one uppercase, one digit, and one special character, and be at least 8 characters long
    pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$'
    return re.match(pattern, password)

@app.route('/admincreate', methods=['GET', 'POST'])
def admincreate():
    if request.method == 'POST':
        username = request.form['username']
        useremail = request.form['email']
        password = request.form['password']
        address = request.form['address']
        agreed = request.form['agree']
        if not is_valid_password(password):
            flash('Password must be at least 8 characters long and include an uppercase letter, a number, and a special character.')
            return redirect(url_for('admincreate'))
        try:
            cursor = mydb.cursor(buffered=True)
            cursor.execute('select count(admin_email) from admin_details where admin_email=%s', [useremail])
            email_count = cursor.fetchone()
        except Exception as e:
            print(f'actual error is {e}')
            flash('Could not reach the data, please try again')
            return redirect(url_for('admincreate'))
        else:
            if email_count[0] == 0:
                otp = gen_otp()
                admindata = {
                    'username': username,
                    'useremail': useremail,
                    'password': password,
                    'address': address,
                    'agreed': agreed,
                    'otp': otp
                }
                subject = 'OTP for Admin Verification'
                body = f'Use the given OTP for admin verification: {otp}'
                send_mail(to=useremail, subject=subject, body=body)
                flash(f'OTP has been sent to the registered email: {useremail}')
                return redirect(url_for('otpverify', endata=entoken(data=admindata)))
            else:
                flash(f'Email already exists: {useremail}')
                return redirect(url_for('admincreate'))
    return render_template('admincreate.html')

@app.route('/otpverify/<endata>',methods=['GET','POST'])
def otpverify(endata):
    if request.method=='POST':
        uotp=request.form['otp']
        ddata=dtoken(data=endata)
        hashed=bcrypt.hashpw(ddata['password'].encode(),bcrypt.gensalt())
        print(hashed)
        print(type(hashed))
        if ddata['otp']==uotp:
            try:
                cursor=mydb.cursor(buffered=True)
                cursor.execute('insert into admin_details(admin_username,admin_email,admin_password,address) values (%s,%s,%s,%s)',[ddata['username'],ddata['useremail'],hashed,ddata['address']])
                mydb.commit()
                cursor.close()
            except Exception as e:
                print(f'The error is {e}')
                flash('Unable to store data')
                return redirect(url_for('admincreate'))
            else:
                flash(f'Admin details successfully stored')
        else:
            flash(f'OTP wrong')
    return render_template('adminotp.html')

@app.route('/adminlogin',methods=['GET','POST'])
def adminlogin():
    if request.method=='POST':
        try:
            useremail=request.form['email']
            password=request.form['password'].encode()
            cursor=mydb.cursor(buffered=True)
            cursor.execute('select count(admin_email) from admin_details where admin_email=%s',[useremail])
            email_count=cursor.fetchone()
        except Exception as e:
            print(e)
            flash('Something went wrong')
            return redirect(url_for('adminlogin'))
        else:
            if email_count[0]==1:
                cursor.execute('select admin_password from admin_details where admin_email=%s',[useremail])
                stored_password=cursor.fetchone()[0]
                print(password,stored_password.decode())
                if bcrypt.checkpw(password,stored_password):
                    session['admin']=useremail
                    return redirect(url_for('admindashboard'))
                else:
                    flash(f'password wrong')
                    return redirect(url_for('adminlogin'))
            elif email_count[0]==0:
                flash(f'{useremail} not found')
                return redirect(url_for('adminlogin'))

    return render_template('adminlogin.html')

@app.route('/admin_forgot', methods=['GET', 'POST'])
def admin_forgot():
    if request.method == 'POST':
        f_email = request.form['email']
        cursor = mydb.cursor(buffered=True)
        cursor.execute('select count(*) from admin_details where admin_email=%s', [f_email])
        count_email = cursor.fetchone()
        if count_email[0] == 1:
            subject = 'Reset link of Ecommerce Website for admin forgot password'
            body = f"Click the reset link: {url_for('admin_newpassword', data=entoken(f_email), _external=True)}"
            send_mail(to=f_email, subject=subject, body=body)
            flash(f'Reset link has been sent to {f_email}')
            return redirect(url_for('admin_forgot'))
        else:
            flash('No account found with that email. Please sign up.')
            return redirect(url_for('adminlogin'))
    return render_template('admin_forgot.html')


@app.route('/admin_newpassword/<data>', methods=['GET', 'POST'])
def admin_newpassword(data):
    if request.method == 'POST':
        npassword = request.form['new-password']
        cpassword = request.form['confirm-password']
        if npassword == cpassword:
            email = dtoken(data)
            print(npassword,cpassword)
            hashed = bcrypt.hashpw(npassword.encode(), bcrypt.gensalt()) 
            cursor = mydb.cursor(buffered=True)
            cursor.execute('update admin_details set admin_password=%s where admin_email=%s', [hashed, email])
            mydb.commit()
            flash('New password updated successfully. Please login.')
            return redirect(url_for('adminlogin')) 
        else:
            flash('Passwords do not match. Please try again.')
            return redirect(url_for('admin_newpassword', data=data))
    return render_template('admin_confirm.html')

    
@app.route('/admindashboard')
def admindashboard():
    return render_template('adminpanel.html')

@app.route('/additem',methods=['GET','POST'])
def additem():
    if request.method=='POST':
        item_name=request.form['title']
        item_desc=request.form['Description']
        item_quantity=request.form['quantity']
        item_cost=request.form['price']
        item_category=request.form['category']
        item_image=request.files['file']
        # print(item_image)
        # print(item_image.filename)
        # print(item_image.filename.split('.'))
        # print(item_image.filename.split('.')[-1])
        filename=gen_otp()+'.'+item_image.filename.split('.')[-1]
        try:
            path=os.path.abspath(__file__)
            dname=os.path.dirname(path)
            print(dname)
            static_path=os.path.join(dname,'static')
            print(static_path)
            item_image.save(os.path.join(static_path,filename))
            cursor=mydb.cursor(buffered=True)
            cursor.execute('insert into items(itemid,item_name,description,item_cost,item_quantity,item_category,added_by,imgname) values(uuid_to_bin(uuid()),%s,%s,%s,%s,%s,%s,%s)',[item_name,item_desc,item_cost,item_quantity,item_category,session.get('admin'),filename])
            mydb.commit()
            cursor.close()
        except Exception as e:
            print(f'Error : {e}')
            flash('Couldnot add the item')
            return redirect(url_for('additem'))
        else:
            flash(f'{item_name[:10]}.. added successfully')
            return redirect(url_for('additem'))
    return render_template('additem.html')

@app.route('/viewitems')
def viewitems():
    if session.get('admin'):
        try:
            cursor=mydb.cursor(buffered=True)
            cursor.execute('select bin_to_uuid(itemid),item_name,item_cost,imgname,description from items where added_by=%s',[session.get('admin')])
            itemsdata=cursor.fetchall()
        except Exception as e:
            print(f'the error is {e}')
            flash('Could not fetch the data')
            return redirect(url_for('admindashboard'))
        else:
            return render_template('viewall_items.html',itemsdata=itemsdata)
    else:
        flash(f'Please login first')
        return redirect(url_for('adminlogin'))

@app.route('/view_item/<itemid>')
def view_item(itemid):
    try:
        cursor=mydb.cursor(buffered=True)
        cursor.execute('select bin_to_uuid(itemid),item_name,description,item_cost,item_quantity,item_category,created_at,imgname from items where itemid=uuid_to_bin(%s) and added_by=%s',[itemid,session.get('admin')])
        itemdata=cursor.fetchone()
    except Exception as e:
        print(f'ERROR IS: {e}')
        flash("Couldn't fetch the data")
        return redirect(url_for('viewitems'))
    else:
        return render_template('view_item.html',itemdata=itemdata)
    return render_template('view_item.html')

@app.route('/updateitem/<itemid>',methods=['GET','POST'])
def updateitem(itemid):
    try:
        cursor=mydb.cursor(buffered=True)
        cursor.execute('select bin_to_uuid(itemid),item_name,description,item_cost,item_quantity,item_category,created_at,imgname from items where itemid=uuid_to_bin(%s) and added_by=%s',[itemid,session.get('admin')])
        itemdata=cursor.fetchone()
    except Exception as e:
        print(f'ERROR IS: {e}')
        flash("Couldn't fetch the data")
        return redirect(url_for('viewitems'))
    else:
        if request.method=='POST':
            item_name=request.form['title']
            item_desc=request.form['Description']
            item_price=request.form['price']
            item_category=request.form['category']
            print(item_category)
            item_quantity=request.form['quantity']
            item_image=request.files['file']
            if item_image.filename=='':
                filename=itemdata[7]
            else:
                filename=gen_otp()+'.'+item_image.filename.split('.')[-1]
                path=os.path.abspath(__file__)
                dname=os.path.dirname(path)
                print(dname)
                static_path=os.path.join(dname,'static')
                print(static_path)
                item_image.save(os.path.join(static_path,filename))
            cursor=mydb.cursor(buffered=True)
            cursor.execute('update items set item_name=%s,description=%s,item_cost=%s,item_quantity=%s,item_category=%s,imgname=%s where itemid=uuid_to_bin(%s) and added_by=%s',[item_name,item_desc,item_price,item_quantity,item_category,filename,itemid,session.get('admin')])
            mydb.commit()
            cursor.close()
            flash('item updated')
            return redirect(url_for('view_item',itemid=itemid))
        return render_template('update_item.html',item_data=itemdata)

@app.route('/deleteitem/<itemid>')
def deleteitem(itemid):
    try:
        cursor=mydb.cursor(buffered=True)
        cursor.execute('select imgname from items where itemid=uuid_to_bin(%s) and added_by=%s',[itemid,session.get('admin')])
        stored_imgname=cursor.fetchone()[0]
        path=os.path.abspath(__file__)
        dname=os.path.dirname(path)
        static_path=os.path.join(dname,'static')
        os.remove(os.path.join(static_path,stored_imgname))
        cursor.execute('delete from items where itemid=uuid_to_bin(%s) and added_by=%s',[itemid,session.get('admin')])
        mydb.commit()
        cursor.close()
    except Exception as e:
        print(e)
        flash(f'Item could not delete')
        return redirect(url_for('viewitems'))
    else:
        flash(f'{itemid} deleted successfully')
        return redirect(url_for('viewitems'))

@app.route('/update_profile', methods=['GET', 'POST']) 
def update_profile():
    if not session.get('admin'):
        return redirect(url_for('adminlogin'))
    admin_session_email = session['admin']
    try:
        cursor = mydb.cursor(dictionary=True)
        cursor.execute('select * from admin_details where admin_email = %s',[admin_session_email])
        admin_data = cursor.fetchone()
    except Exception as e:
        print(f'Error fetching admin details: {e}')
        flash('Could not fetch admin details')
        return redirect(url_for('adminlogin'))
    if not admin_data:
        flash('Admin not found.')
        return redirect(url_for('adminlogin'))
    if request.method == 'POST':
        try:
            admin_name = request.form['adminname']
            admin_email = request.form['email']
            admin_address = request.form['address']
            cursor.execute('update admin_details set admin_username = %s, admin_email = %s, address = %s WHERE admin_email = %s',(admin_name, admin_email, admin_address, admin_session_email))
            mydb.commit()
            cursor.close()
            # Update session if email changed
            if admin_email != admin_session_email:
                session['admin'] = admin_email
            flash('Profile has been updated successfully')
            return redirect(url_for('admindashboard'))
        except Exception as e:
            print(f'Update Error: {e}')
            flash('Update failed')
    return render_template('adminupdate.html', admin=admin_data)


@app.route('/adminlogout')
def adminlogout():
    if session.get('admin'):
        session.pop('admin')
        return redirect(url_for('adminlogin'))
    else:
        flash('Before you logout, first Login')
        return redirect(url_for('adminlogin'))

@app.route('/usersignup', methods=['GET', 'POST'])
def usersignup():
    if request.method == 'POST':
        uname = request.form['name']
        uemail = request.form['email']
        uaddress = request.form['address']
        upassword = request.form['password']
        ugender = request.form['gender']

        # ✅ Validate password
        if not is_valid_password(upassword):
            flash('Password must be at least 8 characters long and include an uppercase letter, a number, and a special character.')
            return redirect(url_for('usersignup'))

        try:
            cursor = mydb.cursor()
            cursor.execute('select count(useremail) from users where useremail=%s', [uemail])
            user_email_count = cursor.fetchone()
        except Exception as e:
            print(f'Actual error is {e}')
            flash('Could not reach the data, please try again')
            return redirect(url_for('usersignup'))
        else:
            if user_email_count[0] == 0:
                uotp = gen_otp()
                userdata = {
                    'username': uname,
                    'useremail': uemail,
                    'password': upassword,
                    'address': uaddress,
                    'gender': ugender,
                    'otp': uotp
                }
                subject = 'OTP for User Verification'
                body = f'Use the given OTP for user verification: {uotp}'
                send_mail(to=uemail, subject=subject, body=body)
                flash(f'OTP has been sent to the registered email: {uemail}')
                return redirect(url_for('user_otpverify', endata=entoken(data=userdata)))
            else:
                flash(f'Email already exists: {uemail}')
                return redirect(url_for('usersignup'))
                
    return render_template('usersignup.html')

@app.route('/user_otpverify/<endata>',methods=['GET','POST'])
def user_otpverify(endata):
    if request.method=='POST':
        uotp=request.form['userotp']
        ddata=dtoken(data=endata)
        hashed=bcrypt.hashpw(ddata['password'].encode(),bcrypt.gensalt())
        print(hashed)
        print(type(hashed))
        if ddata['otp']==uotp:
            try:
                cursor=mydb.cursor(buffered=True)
                cursor.execute('insert into users(username,useremail,password,address,gender) values (%s,%s,%s,%s,%s)',[ddata['username'],ddata['useremail'],hashed,ddata['address']])
                mydb.commit()
                cursor.close()
            except Exception as e:
                print(f'The error is {e}')
                flash('Unable to store data')
                return redirect(url_for('usersignup'))
            else:
                flash(f'User details successfully stored')
        else:
            flash(f'OTP wrong')
    return render_template('userotp.html')

@app.route('/userlogin',methods=['GET','POST'])
def userlogin():
    if request.method=='POST':
        try:
            uemail=request.form['email']
            password=request.form['password'].encode()
            cursor=mydb.cursor(buffered=True)
            cursor.execute('select count(useremail) from users where useremail=%s',[uemail])
            user_email_count=cursor.fetchone()
        except Exception as e:
            print(e)
            flash('Something went wrong')
            return redirect(url_for('userlogin'))
        else:
            if user_email_count[0]==1:
                cursor.execute('select password from users where useremail=%s',[uemail])
                user_stored_password=cursor.fetchone()[0]
                print(password,user_stored_password.decode())
                if bcrypt.checkpw(password,user_stored_password):
                    print(session)
                    session['user']=uemail
                    if not session.get(uemail):
                        session[uemail]={}
                        session.modify=True
                    print(session)
                    return redirect(url_for('index'))
                else:
                    flash(f'password wrong')
                    return redirect(url_for('userlogin'))
            elif user_email_count[0]==0:
                flash(f'{uemail} not found')
                return redirect(url_for('userlogin'))
    return render_template('userlogin.html')
    
@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html')

@app.route('/category/<ctype>')
def category(ctype):
    try:
        cursor=mydb.cursor(buffered=True)
        cursor.execute('select bin_to_uuid(itemid),item_name,description,item_cost,item_quantity,item_category,created_at,imgname from items where item_category=%s',[ctype])
        items_data=cursor.fetchall()
    except Exception as e:
        print(f'Error is : {e}')
        flash('Could not fetch the items')
        return redirect(url_for('index'))
    return render_template('dashboard.html',items_data=items_data)

@app.route('/addcart/<itemid>/<name>/<price>/<category>/<img>')
def addcart(itemid,name,price,category,img):
    print(session)
    if session.get('user'):
        if itemid not in session.get('user'):
            session[session.get('user')][itemid]=[name,price,1,img,category]
            session.modify=True
            flash(f'{name[0:10]} item added to cart')
            return redirect(url_for('index'))
            print(f"Received category: {category}, image: {img}")
        else:
            session[session.get('user')][itemid][2]+=1
            flash(f'item already added to the cart')
            return redirect(url_for('index'))
    else:
        return redirect(url_for('userlogin'))

@app.route('/viewcart')
def viewcart():
    if session.get('user'):
        items=session[session.get('user')]
        if items:
            return render_template('cart.html',items=items)
        else:
            flash('NO items found in the cart')
            return redirect(url_for('index'))
    else:
        flash('Plz login first')
        return redirect(url_for('userlogin'))

@app.route('/removecart/<itemid>')
def removecart(itemid):
    if session.get('user'):
        if session[session.get('user')]:
            session[session.get('user')].pop(itemid)
            session.modify=True
            flash(f'{itemid} removed successfully')
            return redirect(url_for('viewcart'))
        else:
            flash('No items found')
            return redirect(url_for('viewcart'))
    else:
        flash('Plz login first')
        return redirect(url_for('userlogin'))

@app.route('/pay/<itemid>/<name>/<float:price>',methods=['GET','POST'])
def pay(itemid,name,price):
    if session.get('user'):
        try:
            if request.method=='POST':
                qyt=int(request.form['qyt'])
            else:
                qyt=int(quantity)
            price=price*100
            amount=price*qyt
            print(amount,qyt)
            print(f'creating payment for item: {itemid}, name : {name}, price :{amount}')
            order=client.order.create({ 
                "amount" : amount,
                "currency" : "INR",
                "payment_capture" : '1'})
            print(f'order created: {order}')
            return render_template('pay.html',order=order,itemid=itemid,name=name,total_amount=amount)
        except Exception as e:
            print(f'Error is {e}')
            return redirect(url_for('viewcart'))
        return render_template('pay.html')
    else:
        flash('Plz login first')
        return redirect(url_for('userlogin'))

@app.route('/success',methods=['GET','POST'])
def success():
    if request.method=='POST':
        payment_id=request.form['razorpay_payment_id']
        order_id=request.form['razorpay_order_id']
        order_signature=request.form['razorpay_signature']
        itemid=request.form['itemid']
        name=request.form['name']
        total_amount=request.form['total_amount']
        params_dict={
            'razorpay_payment_id':payment_id,
            'razorpay_order_id':order_id,
            'razorpay_signature':order_signature
        }
        try:
            client.utility.verify_payment_signature(params_dict)
        except razorpay.errors.SignatureVerificationError:
            return 'Payment verification failed',400
        else:
            cursor=mydb.cursor(buffered=True)
            cursor.execute('insert into orders(item_id,item_name,total,payment_by) values(uuid_to_bin(%s),%s,%s,%s)',[itemid,name,total_amount,session.get('user')])
            mydb.commit()
            flash(f'Order placed with {total_amount}')
            return redirect(url_for('index'))

@app.route('/description/<itemid>')
def description(itemid):
    try:
        cursor=mydb.cursor(buffered=True)
        cursor.execute('select bin_to_uuid(itemid),item_name,description,item_cost,item_quantity,item_category,created_at,imgname from items where itemid=uuid_to_bin(%s)',[itemid])
        itemdata=cursor.fetchone()
    except Exception as e:
        print(f'Error is : {e}')
        flash('Could not fetch the item details')
        return redirect(url_for('index'))
    else:
        return render_template('description.html',itemdata=itemdata)

@app.route('/add_review/<itemid>',methods=['GET','POST'])
def add_review(itemid):
    if session.get('user'):
        if request.method=='POST':
            review_desc=request.form['review']
            rating=request.form['rate']
            cursor=mydb.cursor(buffered=True)
            print(f'itemid = {itemid}')
            cursor.execute('insert into reviews(review_text,itemid,added_by,rating) values(%s,uuid_to_bin(%s),%s,%s)',[review_desc,itemid,session.get('user'),rating])
            mydb.commit()
            flash(f'Review added successfully')
            return redirect(url_for('description',itemid=itemid))
        return render_template('review.html')
    else:
        flash(f'Plz login to add review')
        return redirect(url_for('description',itemid=itemid))

@app.route('/readreviews/<itemid>')
def readreviews(itemid):
    try:
        cursor=mydb.cursor()
        cursor.execute('select bin_to_uuid(itemid),item_name,description,item_cost,item_quantity,item_category,imgname,created_at from items where itemid=uuid_to_bin(%s)',[itemid])
        itemdata=cursor.fetchone()
        cursor.execute('select * from reviews where itemid=uuid_to_bin(%s)',[itemid])
        reviewdata=cursor.fetchall()

    except Exception as e:
        print(f'Error is {e}')
        flash(f'Couldnot fetch details')
        return redirect(url_for('description',itemid=itemid))
    else:
        return render_template('readreview.html',reviewdata=reviewdata,itemdata=itemdata)

@app.route('/myorders')
def myorders():
    if session.get('user'):
        try:
            cursor = mydb.cursor()
            cursor.execute("select order_id,order_date,item_name,total,payment_by from orders where payment_by=%s order by order_date",[session.get('user')])
            orders = cursor.fetchall()
        except Exception as e:
            print(f'Error is {e}')
            flash('Couldnot fetch the order details')
        else:
            return render_template('orders.html', orders=orders)
    else:
        flash('Please log in to view your orders')
        return redirect(url_for('userlogin'))

@app.route('/getinvoice/<int:ordid>.pdf')
def getinvoice(ordid):
    if session.get('user'):
        try:
            cursor=mydb.cursor(buffered=True)
            cursor.execute('select order_id,order_date,item_name,total from orders where order_id=%s and payment_by=%s',[ordid,session.get('user')])
            order_data=cursor.fetchone()
            cursor.execute('select useremail,username,address,gender from users where useremail=%s',[session.get('user')])
            user_data=cursor.fetchone()
            html=render_template('bill.html',order_data=order_data,user_data=user_data)
            pdf=pdfkit.from_string(html,False,configuration=config)
            response=Response(pdf,content_type='application/pdf')
            response.headers['Content-Disposition']='inline; filename=output.pdf'
            return response
        except Exception as e:
            print(f'Error is {e}')
            flash('Could not convert pdf')
            return redirect(url_for('myorders'))
    else:
        flash('Login to download pdf')
        return redirect(url_for('userlogin'))

@app.route('/contact',methods=['GET','POST'])
def contact():
    if request.method=='POST':
        name=request.form['title']
        email=request.form['email']
        complaint=request.form['description']
        try:
            cursor=mydb.cursor(buffered=True)
            cursor.execute('insert into contact(username,useremail,complaint) values(%s,%s,%s)',[name,email,complaint])
            mydb.commit()
        except Exception as e:
            print(f'Error is {e}')
            flash('Could not add complaint')
        else:
            return redirect(url_for('index'))
    else:
        return render_template('contact.html')

@app.route('/user_forgot', methods=['GET', 'POST'])
def user_forgot():
    if request.method == 'POST':
        f_email = request.form['email']
        cursor = mydb.cursor(buffered=True)
        cursor.execute('select count(*) from users where useremail=%s', [f_email])
        count_email = cursor.fetchone()
        if count_email[0] == 1:
            subject = 'Reset link of Ecommerce Website for User forgot password'
            body = f"Click the reset link: {url_for('user_newpassword', data=entoken(f_email), _external=True)}"
            send_mail(to=f_email, subject=subject, body=body)
            flash(f'Reset link has been sent to {f_email}')
            return redirect(url_for('user_forgot'))
        else:
            flash('No account found with that email. Please sign up.')
            return redirect(url_for('userlogin'))
    return render_template('user_forgot.html')

@app.route('/user_newpassword/<data>', methods=['GET', 'POST'])
def user_newpassword(data):
    if request.method == 'POST':
        npassword = request.form['new-password']
        cpassword = request.form['confirm-password']
        if npassword == cpassword:
            email = dtoken(data)
            hashed = bcrypt.hashpw(npassword.encode(), bcrypt.gensalt()) 
            cursor = mydb.cursor(buffered=True)
            cursor.execute('update users set password=%s where useremail=%s', [hashed, email])
            mydb.commit()
            flash('New password updated successfully. Please login.')
            return redirect(url_for('userlogin')) 
        else:
            flash('Passwords do not match. Please try again.')
            return redirect(url_for('user_newpassword', data=data))
    return render_template('user_confirm.html')

@app.route('/search',methods=['GET','POST'])
def search():
    if request.method=='POST':
        sdata=request.form['search']
        strg=['A-Za-z0-9']
        pattern=re.compile(f'^{strg}', re.IGNORECASE)
        if (pattern.search(sdata)):
            print('hi')
            try:
                cursor=mydb.cursor(buffered=True)
                cursor.execute('select bin_to_uuid(itemid),item_name,description,item_cost,item_quantity,item_category,created_at,imgname from items where itemid like %s or item_name like %s or description like %s or item_cost like %s or item_category like %s or created_at like %s',['%'+sdata+'%','%'+sdata+'%','%'+sdata+'%','%'+sdata+'%','%'+sdata+'%','%'+sdata+'%'])
                items_data=cursor.fetchall()
            except Exception as e:
                print(f'error is {e}')
                flash('Could not fetch search data')
                return redirect(url_for('index'))
            else:
                return render_template('dashboard.html',items_data=items_data)
        else:
            flash('No data found')
            return redirect(url_for('index'))

@app.route('/userlogout')
def userlogout():
    if session.get('user'):
        session.pop('user')
        session.modify=True
        return redirect(url_for('userlogin'))
    else:
        flash('Before you logout, first Login')
        return redirect(url_for('userlogin'))
        
app.run(use_reloader=True,debug=True)
