using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Projector))]
public class AnimatedProjector : MonoBehaviour {

    [SerializeField] float fps = 30.0f;

    [SerializeField] RenderTexture causticsTex;
    private int frameIndex;
    private Projector projector;


	// Use this for initialization
	void Start () {

        projector = GetComponent<Projector>();
	}
	
	void Update () {

        projector.material.SetTexture("_MainTex", causticsTex);

	}
}
