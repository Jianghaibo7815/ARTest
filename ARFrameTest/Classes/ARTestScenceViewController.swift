//
//  ARTestScenceViewController.swift
//  SCTest
//
//  Created by jianghaibo on 2020/12/17.
//

import Foundation
import UIKit
import ARKit
import SceneKit

public class ARSceneViewController: UIViewController {
    
    @available(iOS 11.0, *)
    lazy var configuration: ARWorldTrackingConfiguration = {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        
        return config
    }()
    @available(iOS 11.0, *)
    lazy var session: ARSession = {
        let session = ARSession()
        session.delegate = self
        
        return session
    }()
    @available(iOS 11.0, *)
    lazy var arview: ARSCNView = {
        let frame = view.bounds
        let arv = ARSCNView(frame: frame)
        arv.automaticallyUpdatesLighting = true
        arv.session = self.session
        arv.delegate = self
        
        return arv
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            view.addSubview(arview)
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            session.run(configuration, options: .resetTracking)
        } else {
            // Fallback on earlier versions
        }
        
        if let node = innerNode {
            if #available(iOS 11.0, *) {
                arview.scene.rootNode.addChildNode(node)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    lazy var innerNode: SCNNode? = {
        let scene = SCNScene(named: "Models.scnassets/ship.scn")
        let node = scene?.rootNode
        
        return node
    }()
}

extension ARSceneViewController: ARSessionDelegate {
    @available(iOS 11.0, *)
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print("抓取到新的帧：\(frame)")
        
        
    }
}

extension ARSceneViewController: ARSCNViewDelegate {
    @available(iOS 11.0, *)
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        
        return node
    }
}
