//
//  RatingControl.swift
//  FoodManagement2021
//
//  Created by CNTT on 5/7/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

//Day la file dung de tao ra rating( 5 nut sao)
//Tiet dau to @IBDesign dung de hien thi class ma k can chay code ( Bien dich truco => dua vao giao dien)
@IBDesignable class RatingControl: UIStackView {
    //MARK: properties
    private var ratingButtons = [UIButton]();
    //Bien rating : danh gia san pham
    @IBInspectable var ratingValue:Int = 3{
        didSet{
            updateRatingButtonState();
        }
    }
    
    //@IBInspec... va dinh nghia kieu du lieu ( khai bao tuong minh KDL) se dua thuoc tinh nay vao bang inspect control
    
    //Dinh nghia them ham didSet : moi khi gia tri ben ratingControl thay doi => cap nhap ben story board (didSet duoc goi ngay)
    @IBInspectable var starNumber:Int = 5{
        didSet{
            setUpRatingControl();
        }
    }
    
    //Kich thuoc trong ios dung CG Size : Core Graphic
    @IBInspectable  var starSize:CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setUpRatingControl();
        }
    }
    
    //MARK: initialization

    // 1 doi tuong view co 2 constructor, 1 dung khi code, 1 dung khi keo tu thu vien vao
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpRatingControl()
    }
    
    //duoi day la constructor dung khi keo tu thu vien
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpRatingControl()
    }
    
    //MARK: Rating Button Initialization
    private func setUpRatingControl(){
        //load anh vao bien
        //Sau khi dua anh vao, chi khi chay code moi load anh, de hien thi ben story board
        let bundle = Bundle(for: type(of: self));
        
        //dua bundle vao de hien thi anh ben story board
        let normal = UIImage(named: "normal",in: bundle, compatibleWith: .none);
        let pressed = UIImage(named: "pressed",in: bundle, compatibleWith: .none);
        let selected = UIImage(named: "selected",in: bundle, compatibleWith: .none);
        
        //Xoa cac nut cu khi thay doi gia tri starNumber
        for button in ratingButtons{
            //O stack view, phai dung 2 phuong thuc 2 stack view : button vs stack view va stack view vs button
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        //Xoa button trong mang rating button
        ratingButtons.removeAll();
        
        for _ in 0..<starNumber {
        //Tao nut
        let button = UIButton()
//        button.backgroundColor = UIColor.red;
        
            //set anh vao button
        button.setImage(normal, for: .normal);
        button.setImage(pressed, for: .highlighted);
        button.setImage(selected, for: .selected);
        
        //Setup button's attribute
        //bat buoc phai co constranit de rang buoc height
        //is active = true de rang buoc co hieu luc
            // = false de rang buoc bi bai bo ( neu so sao qua lon, hay de gia tri la false)
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = false
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = false
            
        //Them su kien cho nut
            //Su dung add target, target: self
            button.addTarget(self, action: #selector(ratingButtonPress(button:)), for: .touchUpInside)
        
        //Dua button vao trong layout Rating control
        //ham duoi add doi tuong vao trong view voi thu tu xac dinh
        //..<5 == 0 toi 5 nhung phai < 5
            addArrangedSubview(button);
            
        //Them nut vao mang
            ratingButtons.append(button);
            
        //Goi ham update rating button state
            updateRatingButtonState();
        }
    }
    
    //MARK: Su kien khi bam vao moi nut Rating
    @objc private func ratingButtonPress(button:UIButton){
        if let index = ratingButtons.firstIndex(of: button){
            if ratingValue == index+1{
                ratingValue -= 1;
            }
            else{
                ratingValue = index+1;
            }
            
            updateRatingButtonState()
        }
    }
    
    private func updateRatingButtonState(){
        //Cap nhap trang thai cua cac nut
        //Chuyen dang enum => moi phan tu tra ve bao gom 2 gia tri
        //i : vi tri phan tu
        //button : gia tri phan tu
        for (i,button) in ratingButtons.enumerated(){
            button.isSelected = i < ratingValue
        }
    }
}

