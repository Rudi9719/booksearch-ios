//
//  CallbackOnMainHelperFunctions.swift
//  BookSearch
//
import UIKit

func callbackOnMain(callback: () -> ()) {
    dispatch_async(dispatch_get_main_queue()) {
        callback()
    }
}

func callbackOnMain<T1>(callback: (p1: T1) -> (), _ param1: T1) {
    dispatch_async(dispatch_get_main_queue()) {
        callback(p1: param1)
    }
}

func callbackOnMain<T1, T2>(callback: (p1: T1, p2: T2) -> (), _ param1: T1, _ param2: T2) {
    dispatch_async(dispatch_get_main_queue()) {
        callback(p1: param1, p2: param2)
    }
}

func callbackOnMain<T1, T2, T3>(callback: (p1: T1, p2: T2, p3: T3) -> (), _ param1: T1, _ param2: T2, _ param3: T3) {
    dispatch_async(dispatch_get_main_queue()) {
        callback(p1: param1, p2: param2, p3: param3)
    }
}

func callbackOnMain<T1, T2, T3, T4>(callback: (p1: T1, p2: T2, p3: T3, p4: T4) -> (), _ param1: T1, _ param2: T2, _ param3: T3, _ param4: T4) {
    dispatch_async(dispatch_get_main_queue()) {
        callback(p1: param1, p2: param2, p3: param3, p4: param4)
    }
}

func callbackOnMain<T1, T2, T3, T4, T5>(callback: (p1: T1, p2: T2, p3: T3, p4: T4, p5: T5) -> (), _ param1: T1, _ param2: T2, _ param3: T3, _ param4: T4, _ param5: T5) {
    dispatch_async(dispatch_get_main_queue()) {
        callback(p1: param1, p2: param2, p3: param3, p4: param4, p5: param5)
    }
}

func callbackOnMain<T1, T2, T3, T4, T5, T6>(callback: (p1: T1, p2: T2, p3: T3, p4: T4, p5: T5, p6: T6) -> (), _ param1: T1, _ param2: T2, _ param3: T3, _ param4: T4, _ param5: T5, _ param6: T6) {
    dispatch_async(dispatch_get_main_queue()) {
        callback(p1: param1, p2: param2, p3: param3, p4: param4, p5: param5, p6: param6)
    }
}

func callbackOnMain<T1, T2, T3, T4, T5, T6, T7>(callback: (p1: T1, p2: T2, p3: T3, p4: T4, p5: T5, p6: T6, p7: T7) -> (), _ param1: T1, _ param2: T2, _ param3: T3, _ param4: T4, _ param5: T5, _ param6: T6, _ param7: T7) {
    dispatch_async(dispatch_get_main_queue()) {
        callback(p1: param1, p2: param2, p3: param3, p4: param4, p5: param5, p6: param6, p7: param7)
    }
}

func fixOrientation(img:UIImage) -> UIImage {
    
    if (img.imageOrientation == UIImageOrientation.Up) {
        return img;
    }
    
    UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
    let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
    img.drawInRect(rect)
    
    let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return normalizedImage;
}

func placeHolderImage() -> UIImage {
    return UIImage(named: "no-photo-placeholder")!
}
